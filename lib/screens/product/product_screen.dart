import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard/components/header.dart';
import 'package:flutter_application_1/service/product_service.dart';
import 'package:flutter_application_1/screens/product/product_box.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductDashboardState createState() => _ProductDashboardState();
}

class _ProductDashboardState extends State<ProductScreen> {
  final ProductService _productService = ProductService();
  String searchQuery = '';

  // Ensuring a Future that returns List<Map<String, dynamic>>
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


  void _onProductTap(Map<String, dynamic> product) async {
  final result = await context.push('/product/${product['id']}');
  if (result == true) {
    setState(() {}); // Triggers FutureBuilder to rebuild
    }
  }

  String _getStatusLabel(dynamic status) {
    // Map raw status values to human-readable labels
    switch (status) {
      case 'in_stock':
      case 1:
        return 'In Stock';
      case 'out_of_stock':
      case 0:
        return 'Out Of Stock';
      case 'low_stock':
      case 2:
        return 'Low Stock';
      default:
        return 'Unknown'; // Default for unexpected values
    }
  }

  Color _getStatusColor(String statusLabel) {
    // Return color based on status label
    switch (statusLabel) {
      case 'In Stock':
        return Colors.green;
      case 'Out Of Stock':
        return Colors.red;
      case 'Low Stock':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          bool isTabletOrDesktop = screenWidth > 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                Text(
                  'Add, search, and manage your items all in one place.',
                  style: TextStyle(fontSize: isTabletOrDesktop ? 18 : 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search items',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products available.'));
                      }

                      final products = snapshot.data!
                          .where((product) =>
                      product['name']
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery) ||
                          product['category']
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery))
                          .toList();

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: screenWidth > 600 ? screenWidth : 600,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Product Name')),
                                DataColumn(label: Text('Price')),
                                DataColumn(label: Text('Stock')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Last updated')),
                              ],
                              rows: products.map((product) {
                                final statusLabel = _getStatusLabel(product['status']);
                                final statusColor = _getStatusColor(statusLabel);

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(product['name'].toString()),
                                      onTap: () => _onProductTap(product),
                                    ),
                                    DataCell(
                                      Text(product['price'].toString()),
                                      onTap: () => _onProductTap(product),
                                    ),
                                    DataCell(
                                      Text(product['stock_quantity'].toString()),
                                      onTap: () => _onProductTap(product),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 6,
                                            backgroundColor: statusColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(statusLabel),
                                        ],
                                      ),
                                      onTap: () => _onProductTap(product),
                                    ),
                                    DataCell(
                                      Text(
                                        product['updated_at'] != null
                                            ? DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                product['updated_at']
                                                    .toString()))
                                            : 'N/A',
                                      ),
                                      onTap: () => _onProductTap(product),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, String>? newProduct = await showProductDialog(context);
          if (newProduct != null) {
            bool success = await _productService.addProduct(newProduct);
            if (success) {
              setState(() {}); // Trigger refresh
            } else {
              print('Failed to add product');
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
