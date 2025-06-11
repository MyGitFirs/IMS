  import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;

  const Chart({
    super.key,
    required this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    // Define a list of colors to use for different segments
    final List<Color> colors = [
      primaryColor,
      const Color(0xFF26E5FF),
      const Color(0xFFFFCF26),
      const Color(0xFFEE2727),
      const Color(0xFF9C27B0),
    ];

    // Generate the PieChart sections based on salesData
    List<PieChartSectionData> pieChartSections = salesData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> product = entry.value;

      double salesAmount = (product['totalSalesAmount'] as num).toDouble();
      double quantitySold = (product['totalQuantitySold'] as num).toDouble();

      return PieChartSectionData(
        color: colors[index % colors.length], // Cycle through colors
        value: salesAmount,
        radius: 20 + (quantitySold / 10), // Dynamic radius based on quantity
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartSections,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text(
                  "₱${salesData.fold<double>(0.0, (sum, item) => sum + (item['totalSalesAmount'] as num).toDouble()).toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),
                const Text("Total Sales"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
