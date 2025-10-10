import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/all_rooms_screen/all_rooms_screen.dart';

import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String allRoomsScreen = '/all_rooms_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
    loginScreen: (context) => LoginScreen(),
    allRoomsScreen: (context) => AllRoomsScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => LoginScreen(),
  };
}
