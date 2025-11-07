// Cấu hình kết nối (host/port/user/pass/TLS)
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MqttConfig {
  final String host;
  final int port;
  final bool useTls;
  final String? username;
  final String? password;
  final String clientId;

  const MqttConfig({
    required this.host,
    required this.port,
    required this.useTls,
    this.username,
    this.password,
    required this.clientId,
  });

  MqttConfig copyWith({
    String? host,
    int? port,
    bool? useTls,
    String? username,
    String? password,
    String? clientId,
  }) {
    return MqttConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      useTls: useTls ?? this.useTls,
      username: username ?? this.username,
      password: password ?? this.password,
      clientId: clientId ?? this.clientId,
    );
  }

  Map<String, dynamic> toJson() => {
    'host': host,
    'port': port,
    'useTls': useTls,
    'username': username,
    'password': password,
    'clientId': clientId,
  };

  factory MqttConfig.fromJson(Map<String, dynamic> j) => MqttConfig(
    host: j['host'] as String,
    port: (j['port'] as num).toInt(),
    useTls: (j['useTls'] as bool?) ?? false,
    username: j['username'] as String?,
    password: j['password'] as String?,
    clientId: j['clientId'] as String,
  );

  // Preset nhanh
  factory MqttConfig.hivemqCloud({
    required String host,
    required String username,
    required String password,
    String? clientId,
  }) => MqttConfig(
    host: host,
    port: 8883,
    useTls: true,
    username: username,
    password: password,
    clientId: clientId ?? 'flutter-${DateTime.now().millisecondsSinceEpoch}',
  );

  factory MqttConfig.local({
    String host = '127.0.0.1',
    int port = 1883,
    String clientId = 'flutter-app',
  }) => MqttConfig(
    host: host,
    port: port,
    useTls: false,
    username: null,
    password: null,
    clientId: clientId,
  );

  static const _prefsKey = 'mqtt_config_v2';

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

  // Thêm helper tạo clientId (nếu bạn muốn dùng ở nơi khác)
  static String genClientId([String prefix = 'flutter']) {
    return '$prefix-${DateTime.now().millisecondsSinceEpoch}';
  }

  // Thêm helper xóa cấu hình đã lưu
  // Gọi await MqttConfig.clear(); trước khi save
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
