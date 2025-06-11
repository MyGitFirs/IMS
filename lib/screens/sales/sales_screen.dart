import 'package:flutter_application_1/responsive.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/recent_reports.dart';

class RecentSales extends StatelessWidget {
  const RecentSales({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const SizedBox(height: defaultPadding),
                      const RecentSalesReport(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // No FarmersProductDetails on larger screens
              ],
            ),
          ],
        ),
      ),
    );
  }
}
