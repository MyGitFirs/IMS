import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:flutter_application_1/route/export.dart';
import 'package:provider/provider.dart';

import 'components/scaffold.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: const ResponsiveScaffold(
        child: ProductScreen(),
      ),
    );
  }
}
