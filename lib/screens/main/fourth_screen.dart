import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

import '../profile/profile_screen.dart';
import 'components/scaffold.dart';

class FourthScreen extends StatelessWidget {
  const FourthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: const ResponsiveScaffold(
        child: ProfileScreen(),
      ),
    );
  }
}
