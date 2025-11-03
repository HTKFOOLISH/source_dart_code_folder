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
    _cfg = cfg;

    // Nếu đang có client cũ thì đóng trước
    try {
      _client?.disconnect();
    } catch (_) {}
    _client = MqttServerClient.withPort(cfg.host, cfg.clientId, cfg.port);

    final c = _client!;
    c.keepAlivePeriod = 30;
    c.autoReconnect = true;
    c.resubscribeOnAutoReconnect = true;
    c.logging(on: false);

    if (cfg.useTls) {
      c.secure = true;
      // Nếu dùng broker TLS tự ký trong LAN, mở dòng dưới:
      // c.onBadCertificate = (X509Certificate _) => true;
      c.securityContext = SecurityContext.defaultContext;
    }

    // Callbacks
    c.onConnected = () {
      _connCtrl.add(true);
      _restoreSubscriptions();
    };

    c.onDisconnected = () {
      _connCtrl.add(false);
    };

    c.onSubscribed = (topic) {
      _subscribedTopics.add(topic);
    };

    // Build connect message
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
    try {
      final status = await c.connect(); // Future<MqttClientConnectionStatus?>
      if (status == null || status.state != MqttConnectionState.connected) {
        // Không ném lỗi ra ngoài; chỉ phát tín hiệu disconnected
        _connCtrl.add(false);
        return;
      }
    } catch (_) {
      // Không throw ra ngoài để main.dart không crash
      try {
        c.disconnect();
      } catch (_) {}
      _connCtrl.add(false);
      return;
    }

    // Lắng nghe inbound
    c.updates?.listen((events) {
      if (events == null) return;
      for (final ev in events) {
        final rec = ev;
        final topic = rec.topic;
        final msg = rec.payload;
        if (msg is MqttPublishMessage) {
          final payload = MqttPublishPayload.bytesToStringAsString(
            msg.payload.message,
          );
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
    if (c == null) return;
    if (!isConnected) return;
    c.subscribe(topic, qos);
  }

  void unsubscribe(String topic) {
    _subscribedTopics.remove(topic);
    final c = _client;
    if (c == null) return;
    if (!isConnected) return;
    c.unsubscribe(topic);
  }

  void publishString(
    String topic,
    String payload, {
    MqttQos qos = MqttQos.atLeastOnce,
    bool retain = false,
  }) {
    final c = _client;
    if (c == null) return;
    if (!isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    c.publishMessage(topic, qos, builder.payload!, retain: retain);
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
