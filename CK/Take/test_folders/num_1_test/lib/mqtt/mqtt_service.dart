// mqtt_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt_config.dart';

class MqttIncomingMessage {
  final String topic;
  final String payload; // raw string
  const MqttIncomingMessage(this.topic, this.payload);
}

class MqttService {
  // Singleton
  static final MqttService I = MqttService._();
  MqttService._();

  MqttServerClient? _client;
  MqttConfig? _cfg;

  // Lưu các topic đã subscribe để khôi phục khi reconnect
  final Set<String> _subscribedTopics = {};

  // Broadcast streams
  final _msgCtrl = StreamController<MqttIncomingMessage>.broadcast();
  final _connCtrl = StreamController<bool>.broadcast();

  Stream<MqttIncomingMessage> get messages => _msgCtrl.stream;
  Stream<bool> get connection => _connCtrl.stream;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  /// Kết nối đến broker theo cấu hình; KHÔNG ném exception ra ngoài.
  Future<void> connect(MqttConfig cfg) async {
    // ✅ Nếu đã kết nối với cùng cấu hình thì bỏ qua
    if (isConnected &&
        _cfg != null &&
        _cfg!.host == cfg.host &&
        _cfg!.port == cfg.port &&
        _cfg!.useTls == cfg.useTls &&
        _cfg!.username == cfg.username) {
      print('[MQTT] already connected to ${cfg.host}:${cfg.port}');
      return;
    }

    _cfg = cfg;

    // Đóng client cũ nếu có
    try {
      _client?.disconnect();
    } catch (_) {}
    // _client = MqttServerClient.withPort(cfg.host, cfg.clientId, cfg.port);

    final c = _client = MqttServerClient.withPort(
      cfg.host,
      cfg.clientId,
      cfg.port,
    );

    // dùng MQTT 3.1.1 (v4)
    c.setProtocolV311();

    // Nếu dùng cổng 8884 của HiveMQ Cloud ⇒ WebSocket Secure (WSS)
    if (cfg.port == 8884) {
      c.useWebSocket = true; // bật WebSocket
      c.websocketProtocols =
          MqttClientConstants.protocolsSingleDefault; // ["mqtt"]
    }

    c.keepAlivePeriod = 30;
    c.autoReconnect = true;
    c.resubscribeOnAutoReconnect = true;
    c.connectTimeoutPeriod = 15000; // 15s
    c.logging(on: true); // Bật log SDK

    // TLS chỉ khi cần
    c.secure = cfg.useTls;
    if (cfg.useTls) {
      c.securityContext = SecurityContext.defaultContext;

      // ⚠️ Chỉ bật khi cần test trên emulator nếu gặp CERTIFICATE_VERIFY_FAILED
      // c.onBadCertificate = (Object? cert) {
      //   // ignore: avoid_print
      //   print('[MQTT] WARNING: accepting bad certificate for ${cfg.host}');
      //   return true;
      // };
    } else {
      c.secure = false;
    }

    // Callbacks
    c.onConnected = () {
      print('[MQTT] connected to ${cfg.host}:${cfg.port} (tls=${cfg.useTls})');
      _connCtrl.add(true);
      _restoreSubscriptions(); // ✅ khôi phục các topic đã lưu
    };

    c.onDisconnected = () {
      print('[MQTT] disconnected');
      _connCtrl.add(false);
    };

    c.onSubscribed = (topic) {
      print('[MQTT] subscribed $topic');
      _subscribedTopics.add(topic);
    };

    // Build connect message (MQTT 3.1.1)
    final conn = MqttConnectMessage()
        .withClientIdentifier(cfg.clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    if ((cfg.username ?? '').isNotEmpty) {
      c.connectionMessage = conn.authenticateAs(
        cfg.username!,
        cfg.password ?? '',
      );
    } else {
      c.connectionMessage = conn;
    }

    // Kết nối
    print(
      '[MQTT] connecting to ${cfg.host}:${cfg.port} (tls=${cfg.useTls}) as ${cfg.clientId}',
    );
    MqttClientConnectionStatus? status;
    try {
      // final status = await c.connect(); // Future<MqttClientConnectionStatus?>
      // if (status == null || status.state != MqttConnectionState.connected) {
      //   // Không ném lỗi ra ngoài; chỉ phát tín hiệu disconnected
      //   _connCtrl.add(false);
      //   return;
      // }
      // ✅ Timeout 10s (bạn có thể đổi 15s nếu muốn)
      status = await c.connect().timeout(const Duration(seconds: 10));
      print(
        '[MQTT] connect result: state=${c.connectionStatus?.state} '
        'returnCode=${c.connectionStatus?.returnCode}',
      );
    } on TimeoutException {
      print('[MQTT] connection TIMEOUT');
      try {
        c.disconnect();
      } catch (_) {}
      _connCtrl.add(false);
      return;
    } catch (e, st) {
      print('[MQTT] connection ERROR: $e');
      print(st);
      try {
        c.disconnect();
      } catch (_) {}
      _connCtrl.add(false);
      return;
    }

    if (status == null || status.state != MqttConnectionState.connected) {
      // Không ném lỗi ra ngoài; chỉ phát tín hiệu disconnected
      print(
        '[MQTT] connect failed: ${status?.state} returnCode=${status?.returnCode}',
      );
      _connCtrl.add(false);
      return;
    }

    // Lắng nghe inbound
    c.updates?.listen((events) {
      if (events == null) return;
      for (final ev in events) {
        final topic = ev.topic;
        final msg = ev.payload;
        if (msg is MqttPublishMessage) {
          final payload = MqttPublishPayload.bytesToStringAsString(
            msg.payload.message,
          );
          // print('[MQTT] < $topic $payload'); // mở nếu cần
          _msgCtrl.add(MqttIncomingMessage(topic, payload));
        }
      }
    });
  }

  Future<void> disconnect() async {
    try {
      _client?.disconnect();
    } catch (_) {}
  }

  // ===== Subscribe / Publish =====
  void subscribe(String topic, {MqttQos qos = MqttQos.atLeastOnce}) {
    _subscribedTopics.add(topic);
    final c = _client;
    if (c == null || !isConnected) {
      print('[MQTT] queued subscribe (not connected): $topic');
      return;
    }
    c.subscribe(topic, qos);
  }

  void unsubscribe(String topic) {
    _subscribedTopics.remove(topic);
    final c = _client;
    if (c == null || !isConnected) return;
    c.unsubscribe(topic);
  }

  void publishString(
    String topic,
    String payload, {
    MqttQos qos = MqttQos.atLeastOnce,
    bool retain = false,
  }) {
    final c = _client;
    if (c == null || !isConnected) {
      print('[MQTT] drop publish (not connected) to $topic');
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    c.publishMessage(topic, qos, builder.payload!, retain: retain);
    // print('[MQTT] > $topic $payload'); // mở nếu cần
  }

  void publishJson(
    String topic,
    Map<String, dynamic> jsonMap, {
    MqttQos qos = MqttQos.atLeastOnce,
    bool retain = false,
  }) {
    publishString(topic, jsonEncode(jsonMap), qos: qos, retain: retain);
  }

  void _restoreSubscriptions() {
    final c = _client;
    if (c == null || !isConnected) return;
    for (final t in _subscribedTopics) {
      c.subscribe(t, MqttQos.atLeastOnce);
    }
  }

  void dispose() {
    try {
      _msgCtrl.close();
    } catch (_) {}
    try {
      _connCtrl.close();
    } catch (_) {}
    try {
      _client?.disconnect();
    } catch (_) {}
  }
}
