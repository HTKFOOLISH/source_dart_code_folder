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

  // 1) Load config, cho phép ép ghi đè nếu cần
  var cfg = await MqttConfig.load();
  // BẬT cờ này để ép ghi đè cấu hình (xong test thì đặt lại false)
  const bool DEV_FORCE_OVERWRITE = true;

  // ĐIỀN THÔNG TIN THẬT 3 dòng dưới đây
  const hivemqHost = 'af1af10d2f264a09a3e2dac9ced2e126.s1.eu.hivemq.cloud';
  const hivemqUser = 'admin';
  const hivemqPass = 'Admin123';

  if (cfg == null || DEV_FORCE_OVERWRITE) {
    // ignore: avoid_print
    print("[MQTT]: ghi đè cấu hình HiveMQ Cloud.");
    cfg = MqttConfig.hivemqCloud(
      host: 'af1af10d2f264a09a3e2dac9ced2e126.s1.eu.hivemq.cloud',
      username: 'admin',
      password: 'Admin123',
    ).copyWith(port: 8884);

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
    await MqttService.I.connect(cfg);
  } catch (_) {
    // TODO: log/hiển thị nếu cần
    print('Lỗi kết nối MQTT');
  }

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
