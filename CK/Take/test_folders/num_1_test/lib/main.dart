// main.dart

// CHANGE: Giữ cấu trúc cũ, nhưng thay toàn bộ chỗ dùng MqttConfig.hivemqCloud
// thành MqttConfig.tcp(...) với useTls=true (chuẩn cho HiveMQ Cloud qua TLS/TCP).

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:num_1_test/mqtt/mqtt_config.dart';
import 'package:num_1_test/mqtt/mqtt_service.dart';
import 'package:num_1_test/state/mqtt_room_store.dart';
import 'package:num_1_test/state/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:num_1_test/state/room_provider.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Load config, cho phép ép ghi đè nếu cần
  var cfg = await MqttConfig.load();
  // BẬT cờ này để ép ghi đè cấu hình (xong test thì đặt lại false)
  const bool DEV_FORCE_OVERWRITE = true;

  // ĐIỀN THÔNG TIN THẬT 3 dòng dưới đây
  const hivemqHost = 'af1af10d2f264a09a3e2dac9ced2e126.s1.eu.hivemq.cloud';
  const hivemqUser = 'flutter_user';
  const hivemqPass = 'StrongPass!234';

  if (cfg == null || DEV_FORCE_OVERWRITE) {
    // ignore: avoid_print
    print("[MQTT]: ghi đè cấu hình HiveMQ Cloud.");
    // CHANGE: thay vì .hivemqCloud(...) (không còn), dùng TCP/TLS chuẩn:
    cfg =
        MqttConfig.tcp(
          host: hivemqHost,
          port: 8883, // TLS/TCP của HiveMQ Cloud
          useTls: true, // CHANGE: bật TLS cho cổng 8883
          username: hivemqUser,
          password: hivemqPass,
          clientId: 'flutter-${DateTime.now().millisecondsSinceEpoch}',
          keepAliveSec: 30,
        ).copyWith(
          // CHANGE (tuỳ chọn): cấu hình Last Will nếu muốn thông báo offline
          willTopic: 'home/app/status',
          willPayload: 'offline',
          willQos: 1,
          willRetain: true,
        );

    // Xóa cấu hình cũ và lưu lại
    await MqttConfig.clear(); // xóa cấu hình cũ
    await MqttConfig.save(cfg); // lưu cấu hình mới
  }

  // ignore: avoid_print
  print(
    '[MQTT] USING host=${cfg.host} '
    'port=${cfg.port} tls=${cfg.useTls} '
    'user=${cfg.username} clientId=${cfg.clientId}',
  );

  // 2) Kết nối MQTT một lần qua singleton
  try {
    await MqttService.I.connect(cfg); // CHANGE: dùng API connect mới
  } catch (e) {
    // ignore: avoid_print
    print('Lỗi kết nối MQTT: $e');
  }

  // --- BEGIN: Self-test ping ---
  // CHANGE: Giữ nguyên ý tưởng cũ, ping khi đã connected.
  MqttService.I.connection.listen((ok) {
    if (!ok) return;

    const testTopic = 'diag/ping';
    MqttService.I.subscribe(testTopic);

    StreamSubscription<MqttIncomingMessage>? sub; // khai báo trước
    sub = MqttService.I.messages.listen((m) {
      if (m.topic == testTopic) {
        print('<<< PING RX: ${m.payload}');
        sub?.cancel(); // nhận được 1 lần là đủ để xác nhận pub/sub OK
      }
    });

    final payload = 'hello @ ${DateTime.now().toIso8601String()}';
    print('>>> PING TX: $payload');
    MqttService.I.publishString(testTopic, payload);
  });
  // --- END: Self-test ping ---

  // 3) Cấp cùng MqttService đó cho Store để tránh kết nối lần 2
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomProvider()..load()),
        ChangeNotifierProvider(create: (_) => UserProvider()..load()),
        ChangeNotifierProvider(
          create: (_) => MqttRoomStore(service: MqttService.I),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
