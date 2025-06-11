import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password
  ) async {
    try {
      // Step 1: Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) throw Exception("User creation failed");

      final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Step 2: Save additional user details in Firestore
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'user_id': user.uid,
          'name': name,
          'email': email,
          'user_role': 'admin',
          'created_at': currentDate
        });
      } catch (e) {
        // Delete the created FirebaseAuth user if Firestore write fails
        await user.delete();
        throw Exception('Failed to save user details: $e');
      }
      String? token = await user.getIdToken();
      if (token == null) throw Exception("Failed to retrieve auth token");
      // Step 3: Store data locally using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.uid);
      await prefs.setString('userName', name);
      await prefs.setString('authToken', token);

      return {
        'user': {
          'user_id': user.uid,
          'name': name,
          'email': email,
        },
        'token': token,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return {'error': 'Email already exists'};
      } else {
        return {'error': e.message ?? 'Firebase error'};
      }
    } catch (e) {
      print('Signup failed: $e');
      throw Exception('Signup failed: $e');
    }
  }
}
