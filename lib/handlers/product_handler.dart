import 'package:flutter/material.dart';
import '../service/product_service.dart';  // Ensure correct path to ProductService

class ProductHandler {
  static Future<bool> addProductHandler(
      BuildContext context,
      String name,
      String price,
      String stock,
      String description,
      String? imageFilePath,
      ) async {
    // Validate fields
    if (name.isEmpty || price.isEmpty || stock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false; // Return false for validation failure
    }

    double parsedPrice = double.tryParse(price) ?? 0.0;

    // Construct the product data
    Map<String, dynamic> productData = {
      'name': name,
      'price': parsedPrice,
      'stock_quantity': int.tryParse(stock) ?? 0,
      'description': description,
      'image_url': imageFilePath ?? '',
      'last_updated': DateTime.now().toIso8601String(),
    };

    // Call ProductService to add the product to the backend
    ProductService productService = ProductService();
    bool success = await productService.addProduct(productData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
      return true; // Return true for success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add product')),
      );
      return false; // Return false for failure
    }
  }
}
