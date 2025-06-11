import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllProductsWithUserDetails() async {
    final productSnapshot = await _firestore.collection('products').get();
    final userSnapshot = await _firestore.collection('users').get();

    final users = {
      for (var doc in userSnapshot.docs) doc.id: doc.data()
    };

    return productSnapshot.docs.map((doc) {
      final data = doc.data();
      final userId = data['user_id'];
      final user = users[userId] ?? {};
      return {
        ...data,
        'user_details': user,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateProductStatus(String productId, String status) async {
    await _firestore.collection('products').doc(productId).update({'status': status});
  }

  Future<List<Map<String, dynamic>>> getNewUsers(DateTime lastChecked) async {
    final snapshot = await _firestore
        .collection('users')
        .where('created_at', isGreaterThan: lastChecked.toIso8601String())
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getNewProducts(DateTime lastChecked) async {
    final snapshot = await _firestore
        .collection('products')
        .where('created_at', isGreaterThan: lastChecked.toIso8601String())
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
  try {
    await _firestore.collection('users').doc(userId).update(userData);
    return true;
  } catch (e) {
    print('Error updating user: $e');
    return false;
  }
}


  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) throw Exception("User not found");
    return doc.data()!;
  }
}
