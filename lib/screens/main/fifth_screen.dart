import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

import '../orders/orders_screen.dart';

import 'components/scaffold.dart';

class FifthScreen extends StatelessWidget {
  const FifthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: const ResponsiveScaffold(
        child: AdminOrderScreen(),
      ),
    );
  }
}
