import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Generate a valid 12-digit UPC-A barcode
String _generateUpcABarcode() {
  final random = Random();
  List<int> digits = List.generate(11, (_) => random.nextInt(10)); // 11 random digits

  // Calculate the check digit
  int sumOdd = 0;
  int sumEven = 0;
  for (int i = 0; i < digits.length; i++) {
    if ((i % 2) == 0) {
      sumOdd += digits[i];
    } else {
      sumEven += digits[i];
    }
  }
  int total = (sumOdd * 3) + sumEven;
  int checkDigit = (10 - (total % 10)) % 10;
  digits.add(checkDigit);

  return digits.join();
}


  // Check if a barcode is already used
  Future<bool> _isBarcodeUsed(String barcode) async {
    final snapshot = await _firestore
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // Generate a unique barcode
Future<String> _generateUniqueBarcode() async {
  String barcode;
  int attempts = 0;
  do {
    barcode = _generateUpcABarcode(); // ✅ Generate valid UPC-A
    attempts++;
    if (attempts > 10) throw Exception("Failed to generate unique barcode");
  } while (await _isBarcodeUsed(barcode));
  return barcode;
}


  // Add a new product
  Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final timestamp = DateTime.now().toIso8601String();

      final barcode = await _generateUniqueBarcode(); // 👈 generate and check uniqueness

      await _firestore.collection('products').add({
        'name': productData['name'],
        'description': productData['description'],
        'price': productData['price'],
        'stock_quantity': productData['stock_quantity'],
        'status': "in_stock",
        'image_url': productData['image_url'],
        'user_id': user.uid,
        'barcode': barcode, // 👈 store the barcode
        'created_at': timestamp,
        'updated_at': timestamp,
      });

      return true;
    } catch (e) {
      print("Error adding product: $e");
      return false;
    }
  }

  // Fetch product by document ID
  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (!doc.exists) throw Exception('Product not found');
      final data = doc.data()!;
      data['id'] = doc.id;
      return data;
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // Fetch products for a specific user
  Future<List<Map<String, dynamic>>> fetchProducts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('user_id', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // Update a product by document ID
  Future<bool> updateProduct(String productId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'name': updatedData['name'],
        'description': updatedData['description'],
        'price': updatedData['price'],
        'stock_quantity': updatedData['stock_quantity'],
        'image_url': updatedData['image_url'],
        'updated_at': DateTime.now().toIso8601String(), // Set updated_at on update
      });
      return true;
    } catch (e) {
      print("Error updating product: $e");
      return false;
    }
  }

  // Delete a product by document ID
  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      return true;
    } catch (e) {
      print("Error deleting product: $e");
      return false;
    }
  }
}
