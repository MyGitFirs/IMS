import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _gender = 'Other'; // Default gender selection

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data
    _nameController = TextEditingController(text: widget.userProfile['user']?['name'] ?? '');
    _emailController = TextEditingController(text: widget.userProfile['user']?['email'] ?? '');
    _phoneController = TextEditingController(text: widget.userProfile['phone'] ?? '');
    _addressController = TextEditingController(text: widget.userProfile['address'] ?? '');
    _gender = widget.userProfile['gender'] ?? 'Other';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // Logic to save the changes, such as making an API call
    // Here you might call a user service to update the profile on the backend

    // On success, navigate back
    Navigator.pop(context, {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'gender': _gender,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Phone', _phoneController),
            _buildTextField('Address', _addressController),
            const SizedBox(height: 20),
            Text(
              'Gender',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            DropdownButton<String>(
              value: _gender,
              onChanged: (String? newValue) {
                setState(() {
                  _gender = newValue ?? 'Other';
                });
              },
              items: <String>['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
