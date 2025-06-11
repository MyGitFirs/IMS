import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/components/users/user_details.dart';
import '../../../../service/admin_service.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;

  const UpdateUserScreen({super.key, required this.userId});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AdminService _adminService = AdminService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userDetails = await _adminService.getUserDetails(widget.userId.toString());
      setState(() {
        _nameController.text = userDetails['name'];
        _emailController.text = userDetails['email'];
        _addressController.text = userDetails['address'];
        _phoneController.text = userDetails['phone_number'];
        _genderController.text = userDetails['gender'] ?? '';
        _dobController.text = userDetails['date_of_birth'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'phone_number': _phoneController.text,
      'gender': _genderController.text,
      'date_of_birth': _dobController.text,
      'password_hash': _passwordController.text,
    };

    try {
      final success = await _adminService.updateUser(widget.userId, userData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(id: widget.userId),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 800 ? 600 : constraints.maxWidth * 0.9;
          return Center(
            child: Container(
              width: maxWidth,
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit User Information',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        validatorMessage: 'Please enter a name',
                      ),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        validatorMessage: 'Please enter a valid email',
                        isEmail: true,
                      ),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Address',
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        validatorMessage: 'Please enter a phone number',
                      ),
                      _buildTextField(
                        controller: _genderController,
                        label: 'Gender',
                      ),
                      _buildTextField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        validatorMessage: 'Please enter the date in YYYY-MM-DD format',
                        hint: 'YYYY-MM-DD',
                      ),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        validatorMessage: 'Password must be at least 6 characters',
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: _updateUser,
                        child: const Text('Update User'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMessage,
    String? hint,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator: validatorMessage != null
            ? (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          if (isEmail && !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        }
            : null,
      ),
    );
  }
}
