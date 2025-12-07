// lib/mqtt/mqtt_service.dart
// CHANGE: Tương thích version cũ của mqtt_client:
// - Bỏ websocketPath / websocketProtocols (có thể không tồn tại ở version của bạn)
// - KHÔNG dùng withKeepAliveFor (một số version không có) -> chỉ set client.keepAlivePeriod
// - KHÔNG dùng withCleanSession(bool) -> dùng startClean() khi cần cleanSession=true
// - KHÔNG dùng withWillRetain(bool) -> chỉ gọi withWillRetain() nếu willRetain=true
// - Re-subscribe thủ công trong onConnected

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt_config.dart';
import 'room_payloads.dart';
import 'room_topics.dart';

class MqttIncomingMessage {
  final String topic;
  final String payload; // raw string
  const MqttIncomingMessage(this.topic, this.payload);
}

class MqttService {
  // Singleton để tránh đa kết nối ngoài ý muốn
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
    // Nếu đã kết nối cùng cấu hình thì thôi
    if (isConnected &&
        _cfg != null &&
        _cfg!.host == cfg.host &&
        _cfg!.port == cfg.port &&
        _cfg!.useTls == cfg.useTls &&
        _cfg!.transport == cfg.transport &&
        _cfg!.username == cfg.username) {
      // ignore: avoid_print
      print('[MQTT] already connected to ${cfg.host}:${cfg.port}');
      return;
    }

    _cfg = cfg;

    // Đóng client cũ nếu có
    try {
      _client?.disconnect();
    } catch (_) {}

    // Tạo client mới
    final c = MqttServerClient.withPort(cfg.host, cfg.clientId, cfg.port);
    _client = c;

    // MQTT 3.1.1
    c.setProtocolV311();

    // Thời gian & keepAlive
    c.keepAlivePeriod = cfg.keepAliveSec; // CHANGE: chỉ set ở client
    c.autoReconnect = true;
    c.connectTimeoutPeriod = 20000; // ms
    c.logging(on: true);

    // Transport
    if (cfg.transport == MqttTransport.websocket) {
      c.useWebSocket = true;
      // CHANGE: KHÔNG set websocketPath/websocketProtocols để tránh lỗi version.
      c.secure = cfg.useTls; // WSS nếu true
      if (cfg.useTls) {
        c.securityContext = SecurityContext.defaultContext;
        // c.onBadCertificate = (_) => true; // ⚠ chỉ bật khi debug nội bộ
      }
    } else {
      // TCP / TLS
      c.useWebSocket = false;
      c.secure = cfg.useTls;
      if (cfg.useTls) {
        c.securityContext = SecurityContext.defaultContext;
        // c.onBadCertificate = (_) => true; // ⚠ chỉ bật khi debug nội bộ
      }
    }

    // Callbacks
    c.onConnected = () {
      print('[MQTT] connected');
      _connCtrl.add(true);

      // CHANGE: Re-subscribe thủ công khi vừa kết nối (kể cả autoReconnect)
      if (_cfg?.resubscribeOnAutoReconnect ?? true) {
        for (final t in _subscribedTopics) {
          final res = c.subscribe(t, MqttQos.atLeastOnce);
          print('[MQTT] resubscribe $t -> $res');
        }
      }
    };

    c.onDisconnected = () {
      print('[MQTT] disconnected: ${c.connectionStatus?.state}');
      _connCtrl.add(false);
    };

    c.pongCallback = () => print('[MQTT] PINGRESP received');

    c.onSubscribed = (topic) {
      print('[MQTT] subscribed $topic');
      _subscribedTopics.add(topic);
    };

    // ===== Build connect message =====
    var conn = MqttConnectMessage().withClientIdentifier(cfg.clientId);

    // CHANGE: Version cũ không hỗ trợ withCleanSession(bool).
    // Mặc định cleanSession=false. Nếu bạn muốn cleanSession=true -> gọi startClean().
    if (cfg.cleanSession) {
      conn = conn.startClean(); // set cleanSession = true
    }

    // Username/Password nếu có
    if ((cfg.username ?? '').isNotEmpty) {
      conn = conn.authenticateAs(cfg.username!, cfg.password ?? '');
    }

    // Last Will nếu có
    if ((cfg.willTopic ?? '').isNotEmpty) {
      conn = conn
          .withWillTopic(cfg.willTopic!)
          .withWillMessage(cfg.willPayload ?? '')
          .withWillQos(_qosFromInt(cfg.willQos));
      // CHANGE: withWillRetain() không có tham số; chỉ gọi khi muốn bật retain
      if (cfg.willRetain) {
        conn = conn.withWillRetain();
      }
    }

    c.connectionMessage = conn;

    print(
      '[MQTT] connecting to ${cfg.host}:${cfg.port} '
      '(tls=${cfg.useTls}, transport=${cfg.transport.name}) '
      'as ${cfg.clientId}',
    );

    MqttClientConnectionStatus? status;
    try {
      status = await c.connect();
    } catch (e) {
      print('[MQTT] connect exception: $e');
      _connCtrl.add(false);
      return;
    }

    if (status == null || status.state != MqttConnectionState.connected) {
      print(
        '[MQTT] connect failed: ${status?.state} returnCode=${status?.returnCode}',
      );
      _connCtrl.add(false);
      return;
    }

    // Lắng nghe inbound
    c.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? events) {
      if (events == null) return;
      for (final ev in events) {
        final topic = ev.topic;
        final msg = ev.payload;
        if (msg is MqttPublishMessage) {
          final payload = MqttPublishPayload.bytesToStringAsString(
            msg.payload.message,
          );
          _msgCtrl.add(MqttIncomingMessage(topic, payload));
        }
      }
    });
  }

  // ===== API =====
  Future<void> disconnect() async {
    try {
      _client?.disconnect();
    } catch (_) {}
  }

  /// CHANGE: QoS và retain có thể cấu hình; mặc định atLeastOnce + không retain.
  Future<void> publishString(
    String topic,
    String payload, {
    MqttQos qos = MqttQos.atLeastOnce,
    bool retain = false,
  }) async {
    final c = _client;
    if (c == null || !isConnected) return;
    final builder = MqttClientPayloadBuilder()..addString(payload);
    c.publishMessage(topic, qos, builder.payload!, retain: retain);
  }

  Future<void> publishJson(
    String topic,
    Map<String, dynamic> json, {
    MqttQos qos = MqttQos.atLeastOnce,
    bool retain = false,
  }) async {
    await publishString(topic, jsonEncode(json), qos: qos, retain: retain);
  }

  void subscribe(String topic, {MqttQos qos = MqttQos.atLeastOnce}) {
    final c = _client;
    if (c == null) return;
    c.subscribe(topic, qos);
    _subscribedTopics.add(topic);
  }

  void unsubscribe(String topic) {
    final c = _client;
    if (c == null) return;
    c.unsubscribe(topic);
    _subscribedTopics.remove(topic);
  }

  // Tiện ích gửi lệnh cho phòng
  Future<void> sendRoomCommand(RoomCommand cmd) async {
    await publishString(RoomTopics.command(cmd.roomId), cmd.encode());
  }

  // Tiện ích gửi snapshot trạng thái phòng
  Future<void> sendRoomSnapshot(RoomPacket pkt) async {
    await publishString(RoomTopics.snapshot(pkt.roomId), pkt.encode());
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

MqttQos _qosFromInt(int x) {
  switch (x) {
    case 2:
      return MqttQos.exactlyOnce;
    case 1:
      return MqttQos.atLeastOnce;
    case 0:
    default:
      return MqttQos.atMostOnce;
  }
}
