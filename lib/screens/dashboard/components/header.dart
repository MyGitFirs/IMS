import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:flutter_application_1/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard/components/profilecard.dart';
import 'package:provider/provider.dart';


class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Spacer(),
        const ProfileCard()
      ],
    );
  }
}
