import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:flutter_application_1/screens/sales/sales_screen.dart';
import 'package:provider/provider.dart';

import 'components/scaffold.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: const ResponsiveScaffold(
        child: RecentSales(),
      ),
    );
  }
}
