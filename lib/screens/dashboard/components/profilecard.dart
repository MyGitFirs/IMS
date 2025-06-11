import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../responsive.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  Future<String?> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserName(),
      builder: (context, snapshot) {
        String? userName = snapshot.data ?? 'Guest'; // Default to 'Guest' if userName is null or data is still loading

        return Container(
          margin: const EdgeInsets.only(left: defaultPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/logo/FRESHY.png",
                height: 38,
              ),
              if (!Responsive.isMobile(context))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Text(userName),
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.keyboard_arrow_down),
                onSelected: (value) async {
                  if (value == 'logout') {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    context.go('/login');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.black54),
                          SizedBox(width: 8),
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
