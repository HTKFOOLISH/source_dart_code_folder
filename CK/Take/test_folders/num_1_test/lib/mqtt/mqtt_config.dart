// lib/mqtt/mqtt_config.dart
// CHANGE: Viết lại hoàn toàn cấu hình MQTT để tách bạch transport (TCP/WebSocket),
// hỗ trợ TLS/WSS, keepAlive, cleanSession, Last Will và (de)serialize rõ ràng.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// CHANGE: Thêm enum để mô tả kiểu transport.
enum MqttTransport { tcp, websocket }

class MqttConfig {
  final String host;
  final int port;
  final MqttTransport transport; // CHANGE: mới
  final bool useTls; // TLS (TCP) hoặc WSS (WebSocket + TLS)
  final String? username;
  final String? password;
  final String clientId;

  // CHANGE: mới — cấu hình bổ sung
  final String? wsPath; // ví dụ: '/mqtt' khi dùng WebSocket
  final int keepAliveSec; // mặc định 30
  final bool cleanSession; // mặc định true
  final bool resubscribeOnAutoReconnect; // mặc định true

  // CHANGE: mới — cấu hình Last Will (tuỳ chọn)
  final String? willTopic;
  final String? willPayload;
  final int willQos; // 0,1,2
  final bool willRetain;

  const MqttConfig({
    required this.host,
    required this.port,
    required this.transport, // CHANGE
    required this.useTls,
    required this.username,
    required this.password,
    required this.clientId,
    this.wsPath,
    this.keepAliveSec = 30,
    this.cleanSession = true,
    this.resubscribeOnAutoReconnect = true,
    this.willTopic,
    this.willPayload,
    this.willQos = 1,
    this.willRetain = false,
  });

  MqttConfig copyWith({
    String? host,
    int? port,
    MqttTransport? transport,
    bool? useTls,
    String? username,
    String? password,
    String? clientId,
    String? wsPath,
    int? keepAliveSec,
    bool? cleanSession,
    bool? resubscribeOnAutoReconnect,
    String? willTopic,
    String? willPayload,
    int? willQos,
    bool? willRetain,
  }) {
    return MqttConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      transport: transport ?? this.transport,
      useTls: useTls ?? this.useTls,
      username: username ?? this.username,
      password: password ?? this.password,
      clientId: clientId ?? this.clientId,
      wsPath: wsPath ?? this.wsPath,
      keepAliveSec: keepAliveSec ?? this.keepAliveSec,
      cleanSession: cleanSession ?? this.cleanSession,
      resubscribeOnAutoReconnect:
          resubscribeOnAutoReconnect ?? this.resubscribeOnAutoReconnect,
      willTopic: willTopic ?? this.willTopic,
      willPayload: willPayload ?? this.willPayload,
      willQos: willQos ?? this.willQos,
      willRetain: willRetain ?? this.willRetain,
    );
  }

  Map<String, dynamic> toJson() => {
    'host': host,
    'port': port,
    'transport': transport.name, // CHANGE
    'useTls': useTls,
    'username': username,
    'password': password,
    'clientId': clientId,
    'wsPath': wsPath,
    'keepAliveSec': keepAliveSec,
    'cleanSession': cleanSession,
    'resubscribeOnAutoReconnect': resubscribeOnAutoReconnect,
    'willTopic': willTopic,
    'willPayload': willPayload,
    'willQos': willQos,
    'willRetain': willRetain,
  };

  factory MqttConfig.fromJson(Map<String, dynamic> j) => MqttConfig(
    host: j['host'] as String,
    port: j['port'] as int,
    transport: _parseTransport(j['transport'] as String?),
    useTls: j['useTls'] == true,
    username: j['username'] as String?,
    password: j['password'] as String?,
    clientId: j['clientId'] as String,
    wsPath: j['wsPath'] as String?,
    keepAliveSec: (j['keepAliveSec'] as num?)?.toInt() ?? 30,
    cleanSession: j['cleanSession'] != false,
    resubscribeOnAutoReconnect: j['resubscribeOnAutoReconnect'] != false,
    willTopic: j['willTopic'] as String?,
    willPayload: j['willPayload'] as String?,
    willQos: (j['willQos'] as num?)?.toInt() ?? 1,
    willRetain: j['willRetain'] == true,
  );

  static MqttTransport _parseTransport(String? n) {
    switch (n) {
      case 'websocket':
        return MqttTransport.websocket;
      case 'tcp':
      default:
        return MqttTransport.tcp;
    }
  }

  // ===== Helpers =====

  // CHANGE: factory cho TCP/TLS
  factory MqttConfig.tcp({
    required String host,
    int port = 1883,
    bool useTls = false, // TLS/TCP -> 8883
    String? username,
    String? password,
    String? clientId,
    int keepAliveSec = 30,
  }) => MqttConfig(
    host: host,
    port: port,
    transport: MqttTransport.tcp,
    useTls: useTls,
    username: username,
    password: password,
    clientId: clientId ?? 'flutter-${DateTime.now().millisecondsSinceEpoch}',
    keepAliveSec: keepAliveSec,
  );

  // CHANGE: factory cho WS/WSS
  factory MqttConfig.websocket({
    required String host,
    int port = 80,
    bool useTls = false, // WSS -> 443
    String wsPath = '/mqtt',
    String? username,
    String? password,
    String? clientId,
    int keepAliveSec = 30,
  }) => MqttConfig(
    host: host,
    port: port,
    transport: MqttTransport.websocket,
    useTls: useTls,
    wsPath: wsPath,
    username: username,
    password: password,
    clientId: clientId ?? 'flutter-${DateTime.now().millisecondsSinceEpoch}',
    keepAliveSec: keepAliveSec,
  );

  // CHANGE: local dev
  factory MqttConfig.local() => MqttConfig.tcp(
    host: '127.0.0.1',
    port: 1883,
    useTls: false,
    clientId: 'flutter-local',
  );

  // ====== Persist to SharedPreferences ======
  static const _prefsKey = 'mqtt_config_v2'; // CHANGE: bump key

  static Future<MqttConfig?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return null;
    return MqttConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> save(MqttConfig cfg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(cfg.toJson()));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
