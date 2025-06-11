import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../service/product_service.dart';
import '../main/second_screen.dart';
import 'reviews/review_screen.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  late Future<Map<String, dynamic>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _productService.getProductById(widget.productId);

    _productFuture.then((product) {
      print("Fetched product details: $product");
    }).catchError((error) {
      print("Error fetching product details: $error");
    });
  }

  String formatDate(String date) {
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  }

  Future<bool> deleteProduct(BuildContext context, Map<String, dynamic> product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Delete ${product['name']}"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await Future.delayed(const Duration(milliseconds: 100));

                final success = await _productService.deleteProduct(product['id']);
                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${product['name']} deleted successfully")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to delete ${product['name']}")),
                  );
                }

                Navigator.of(context).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 800;

              return Center(
                child: Container(
                  width: constraints.maxWidth > 1200 ? 1200 : constraints.maxWidth * 0.9,
                  padding: const EdgeInsets.all(16.0),
                  child: Flex(
                    direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Product Image
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: isWideScreen ? 300 : 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(product['image_url'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20, height: 20),

                      // Right Column: Details
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: TextStyle(
                                fontSize: constraints.maxWidth > 600 ? 28 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                              BarcodeWidget(
                                barcode: Barcode.upcA(),
                                data: product['barcode'],
                                width: 200,
                                height: 80,
                                drawText: true,
                                errorBuilder: (context, error) => Text(
                                  'Invalid Barcode',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              const SizedBox(height: 10),


                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Product Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Price: ₱${(product['price'] ?? 0.0).toStringAsFixed(2)}',
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Stock Quantity: ${product['stock_quantity']}',
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Description: ${product['description'] ?? ''}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<Map<String, dynamic>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final product = snapshot.data!;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () async {
                  await context.push(
                    '/edit-product',
                    extra: {
                      ...product,
                      'product_id': widget.productId,
                    },
                  );
                  setState(() {
                    _productFuture = _productService.getProductById(widget.productId);
                  });
                },
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () async {
                  final success = await deleteProduct(context, product);
                  if (success && context.mounted) {
                    context.pop(true);
                  }
                },
                child: const Icon(Icons.delete),
              ),
            ],
          );
        },
      ),
    );
  }
}
