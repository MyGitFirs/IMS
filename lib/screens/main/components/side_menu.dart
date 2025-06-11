import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 80, // Adjust the height to match your ListTile size
            child: Container(
              color: Theme.of(context).primaryColor, // Background color
              alignment: Alignment.center, // Center the text vertically and horizontally
              child: const Text(
                "Scan IT",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,  // Use built-in icons
            press: () {
              context.go('/main');
            },
          ),
          DrawerListTile(
            title: "Items",
            icon: Icons.shopping_bag,  // Change to an appropriate icon
            press: () {
              context.go('/second');
            },
          ),
          DrawerListTile(
            title: "Scan IT",
            icon: Icons.attach_money,  // Change to an appropriate icon
            press: () {
              context.go('/third');
            },
          ),
          DrawerListTile(
            title: "Stocks",
            icon: Icons.shopping_basket,  // Change to an appropriate icon
            press: () {
              context.go('/fifth');
            },
          ),
          DrawerListTile(
            title: "Profile",
            icon: Icons.person,  // Change to an appropriate icon
            press: () {
              context.go('/fourth');
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color ?? Colors.white54,  // Use theme color
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white54),
      ),
    );
  }
}
