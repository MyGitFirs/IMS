import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../service/product_service.dart';

class RecentSalesReport extends StatefulWidget {
  const RecentSalesReport({super.key});

  @override
  _RecentSalesReportState createState() => _RecentSalesReportState();
}

class _RecentSalesReportState extends State<RecentSalesReport> {
  final ProductService _productService = ProductService();
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await _productService.fetchProducts(user.uid);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Products",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Failed to load products',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              } else {
                final products = snapshot.data!;
                return SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    columns: const [
                      DataColumn(label: Text("Product Name")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Created Date")),
                    ],
                    rows: products.map((product) => _productDataRow(product)).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  DataRow _productDataRow(Map<String, dynamic> product) {
    final name = product['name']?.toString() ?? 'N/A';
    final quantity = product['stock_quantity']?.toString() ?? 'N/A';

    String createdAt = 'N/A';
    if (product['created_at'] != null) {
      try {
        final dateTime = DateTime.parse(product['created_at'].toString());
        createdAt = DateFormat('MMM dd, yyyy').format(dateTime);
      } catch (_) {
        createdAt = product['created_at'].toString();
      }
    }

    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(quantity)),
        DataCell(Text(createdAt)),
      ],
    );
  }
}
