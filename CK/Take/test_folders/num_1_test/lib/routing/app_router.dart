// app_router.dart
import 'package:flutter/material.dart';
import 'package:num_1_test/ui/config_screen/user_management_screen.dart'; // <-- THÊM VÀO
// import 'package:num_1_test/models/room.dart';
import 'package:num_1_test/ui/room_screen/living_room/living_room.dart';
import 'package:num_1_test/ui/config_screen/config_room_card.dart';
import '../ui/home_screen/home_screen.dart';
import '../ui/login/login_screen.dart';
import 'app_routes.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case AppRoutes.livingRoom:
      return MaterialPageRoute(
        builder: (_) => LivingRoomRoomArgs(),
        settings: settings,
      );
    case AppRoutes.configRoom:
      return MaterialPageRoute(builder: (_) => const ConfigRoomCard());

    // ##### THÊM CASE NÀY VÀO #####
    case AppRoutes.manageUsers:
      return MaterialPageRoute(builder: (_) => const UserManagementScreen());
    // ##### KẾT THÚC PHẦN THÊM #####

    // case AppRoutes.device:
    // ...
    default:
      return null;
  }
}