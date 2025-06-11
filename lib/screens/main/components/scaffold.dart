import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:flutter_application_1/responsive.dart';
import 'package:provider/provider.dart';

import 'side_menu.dart';


class ResponsiveScaffold extends StatelessWidget {
  final Widget child;

  const ResponsiveScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        var menuController = Provider.of<MenuAppController>(context);

        return Scaffold(
          key: menuController.scaffoldKey,
          drawer: const SideMenu(),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  const Expanded(
                    child: SideMenu(),
                  ),
                Expanded(
                  flex: 5,
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
