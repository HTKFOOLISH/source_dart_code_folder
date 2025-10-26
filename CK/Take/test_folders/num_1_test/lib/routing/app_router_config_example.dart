import 'package:flutter/material.dart';
import 'package:num_1_test/ui/config_screen/config_room_card.dart';
import 'app_routes.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.configRoom:
      return MaterialPageRoute(builder: (_) => const ConfigRoomCard());
    default:
      return null;
  }
}
