import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/screens/dashboard/components/header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, TextEditingController> _controllers = {};
  Map<String, bool> _isEditing = {};
  bool _isLoading = true;
  bool _isSaving = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in';
      });
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userRef.get();
    final userData = userDoc.data() ?? {};

    setState(() {
      _controllers = {
        'name': TextEditingController(text: userData['name'] ?? user.displayName ?? 'N/A'),
        'email': TextEditingController(text: user.email ?? 'N/A'),
      };
      _isEditing = {
        'name': false,
        'email': false,
      };
      _isLoading = false;
    });
  }

  Future<void> _updateUserProfileField(String key) async {
    setState(() {
      _isSaving = true;
      _errorMessage = '';
    });

    String newValue = _controllers[key]?.text ?? '';
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        final userId = user.uid;
        final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

        if (key == 'email') {
          await user.updateEmail(newValue);
        } else if (key == 'name') {
          await user.updateDisplayName(newValue);
          await userRef.set({'name': newValue}, SetOptions(merge: true));
        }

        setState(() {
          _isEditing[key] = false;
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isSaving) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text('Error: $_errorMessage')),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Header(),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/Profile.png'),
              ),
              const SizedBox(height: 10),
              Text(
                _controllers['name']?.text ?? 'N/A',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _controllers['email']?.text ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              _buildEditableInfoRow('Name', 'name'),
              _buildEditableInfoRow('Email', 'email'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableInfoRow(String label, String key) {
    bool isEditing = _isEditing[key] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _controllers[key],
              decoration: InputDecoration(
                labelText: label,
                border: isEditing ? const OutlineInputBorder() : InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
              enabled: isEditing,
            ),
          ),
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: Colors.grey,
            ),
            onPressed: () {
              if (isEditing) {
                _updateUserProfileField(key);
              } else {
                setState(() {
                  _isEditing[key] = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
