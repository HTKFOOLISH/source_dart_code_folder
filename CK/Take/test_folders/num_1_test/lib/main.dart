// main.dart

import 'package:flutter/material.dart';
import 'package:num_1_test/state/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:num_1_test/state/room_provider.dart';
import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomProvider()..load()),
        ChangeNotifierProvider(create: (_) => UserProvider()..load()), // <-- Đã sửa
      ],
      child: const MyApp(),
    ),
  );
}