// main.dart

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

  // Tải cấu hình đã lưu hoặc dùng local broker mặc định để dev nhanh
  final cfg =
      await MqttConfig.load() ??
      MqttConfig.local(
        host: 'broker.hivemq.com',
        port: 1883,
        clientId: 'flutter-app',
      );

  // Kết nối MQTT (bắt lỗi mềm để app vẫn lên được UI)
  try {
    await MqttService.I.connect(cfg);
  } catch (_) {
    // TODO: log/hiển thị nếu cần
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomProvider()..load()),
        ChangeNotifierProvider(create: (_) => UserProvider()..load()),
        ChangeNotifierProvider(create: (_) => MqttRoomStore()),
      ],
      child: const MyApp(),
    ),
  );
}
