import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:flutter_application_1/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'components/scaffold.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: const ResponsiveScaffold(
        child: DashboardScreen(),
      ),
    );
  }
}
