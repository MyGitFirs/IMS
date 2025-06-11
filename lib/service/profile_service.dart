import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the current user profile from Firestore
  Future<Map<String, dynamic>> getUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        throw Exception('User profile not found');
      }

      final data = doc.data()!;
      data['email'] = user.email; // Add auth email if needed
      data['uid'] = user.uid;
      print(data);
      return data;
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
