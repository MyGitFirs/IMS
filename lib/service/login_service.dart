import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      // Step 1: Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) throw 'User not found';

      // Step 2: Get ID token
      String? token = await user.getIdToken();

      // Step 3: Store user data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.uid);
      await prefs.setString('userName', user.displayName ?? 'Unknown');
      await prefs.setString('authToken', token!);

      // Step 4: Return user data
      return {
        'user': {
          'user_id': user.uid,
          'name': user.displayName ?? 'Unknown',
          'email': user.email,
        },
        'token': token,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else {
        throw e.message ?? 'Login failed';
      }
    } catch (e) {
      print('Login failed: $e');
      throw 'Login error: $e';
    }
  }
}
