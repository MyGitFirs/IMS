import 'package:flutter/material.dart';
import '../../../service/admin_service.dart';
import '../admin_screen.dart';
import 'list_products.dart';
import 'users/user_box.dart'; // Import the UserBox component
import 'users/user_details.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final AdminService adminService = AdminService(); // Create an instance of AdminService
  List<Map<String, String>> users = []; // Users fetched from the API
  bool isLoading = true; // State to track loading

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users on initialization
  }

  // Function to fetch users from the API
  Future<void> _fetchUsers() async {
    try {
      final fetchedUsers = await adminService.getAllUsers();
      setState(() {
        // Convert each field to a String explicitly
        users = List<Map<String, String>>.from(fetchedUsers.map((user) => {
          'id': user['user_id'].toString(), // Include the ID
          'userName': user['name'].toString(),
          'userRole': user['user_role'].toString(),
          'joinDate': user['created_at'].toString(),
          'email': user['email'].toString(),
        }));
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        isLoading = false; // Stop loading if there is an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboard()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageProductsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return UserBox(
              userName: user['userName']!,
              userRole: user['userRole']!,
              joinDate: user['joinDate']!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailsScreen(
                      id: user['id']!,
                    ),
                  ),
                ).then((_) {
                  // Reload the user list when returning from the details screen
                  _fetchUsers();
                });
              },
            );
          },
        ),
      ),
    );
  }
}
