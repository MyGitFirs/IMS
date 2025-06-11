import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/admin_service.dart';
import '../manage_user.dart';
import 'edit_user.dart';

class UserDetailsScreen extends StatefulWidget {
  final String id;

  const UserDetailsScreen({super.key, required this.id});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final AdminService adminService = AdminService(); // Initialize the service
  late Future<Map<String, dynamic>> userDetailsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch user details when the widget is initialized
    userDetailsFuture = adminService.getUserDetails(widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to ManageUsersScreen when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ManageUsersScreen()),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: userDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading indicator
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Show error message
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No user details found'));
            }

            final user = snapshot.data!;
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                constraints: const BoxConstraints(maxWidth: 600), // Centered and constrained width
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            user['name'] ?? 'N/A',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(height: 30, thickness: 1.5),
                        // Conditionally render detail rows
                        if (user['user_id'] != null) _buildDetailRow('ID', user['user_id'].toString()),
                        if (user['user_role'] != null) _buildDetailRow('Role', user['user_role']),
                        if (user['email'] != null) _buildDetailRow('Email', user['email']),
                        if (user['address'] != null) _buildDetailRow('Address', user['address']),
                        if (user['phone_number'] != null) _buildDetailRow('Phone Number', user['phone_number']),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateUserScreen(userId: widget.id),
                                ),
                              ).then((_) {
                                // Reload user details when returning from the update screen
                                setState(() {
                                  userDetailsFuture = adminService.getUserDetails(widget.id.toString());
                                });
                              });
                            },
                            child: const Text('Edit User'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis, // Gracefully handle long text
            ),
          ),
        ],
      ),
    );
  }
}
