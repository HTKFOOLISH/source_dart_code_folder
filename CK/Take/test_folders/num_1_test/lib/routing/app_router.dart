import 'package:flutter/material.dart';
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
      return MaterialPageRoute(builder: (_) => const LivingRoom());
    case AppRoutes.configRoom:
      return MaterialPageRoute(builder: (_) => const ConfigRoomCard());
    // case AppRoutes.device:
    // return MaterialPageRoute(builder: (_) => DeviceScreen());
    // case AppRoutes.configDevice:
    //   return MaterialPageRoute(builder: (_) => ConfigDeviceScreen());
    default:
      return null;
  }
}
