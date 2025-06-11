import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../constants.dart';
import 'chart.dart';
import 'product_info_card.dart';

class FarmersProductDetails extends StatelessWidget {
  const FarmersProductDetails({super.key});

  Future<List<Map<String, dynamic>>> fetchProductSales() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final response =
    await http.get(Uri.parse('$baseApiUrl/api/sales/total-sales/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load product sales data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProductSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show a loading spinner while waiting
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load data',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No sales data available',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).hintColor,
                ),
              ),
            );
          } else {
            final productData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Sales Overview",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: defaultPadding),
                // Pass the fetched data to Chart
                Chart(salesData: productData),
                const SizedBox(height: defaultPadding),
                ...productData.map((product) {
                  return ProductInfoCard(
                    svgSrc:
                    "assets/icons/${product['productName'].toLowerCase()}.svg",
                    title: product['productName'],
                    amount: "₱${product['totalSalesAmount']}",
                    numOfItems: product['totalQuantitySold'],
                  );
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
