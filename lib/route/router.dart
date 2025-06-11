import 'package:flutter/material.dart';
import 'export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
      case dashboardScreen:
        return MaterialPageRoute(
        builder: (context) => const MainScreen(),
      );
      case secondScreenRoute:
        return MaterialPageRoute(
        builder: (context) => const SecondScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      );
  }
}