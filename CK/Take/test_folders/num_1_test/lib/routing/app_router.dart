import 'package:flutter/material.dart';
import 'package:num_1_test/ui/room_page/living_room/living_room.dart';
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
    // case AppRoutes.configRoom:
    //   return MaterialPageRoute(builder: (_) => ConfigRoomScreen());
    // case AppRoutes.device:
    // return MaterialPageRoute(builder: (_) => DeviceScreen());
    // case AppRoutes.configDevice:
    //   return MaterialPageRoute(builder: (_) => ConfigDeviceScreen());
    case AppRoutes.livingRoom:
      return MaterialPageRoute(builder: (_) => LivingRoom());
  }
  return null;
}
