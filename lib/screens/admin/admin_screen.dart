import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../service/admin_service.dart'; // Import your service
import '../auth/login.dart';
import 'components/list_products.dart';
import 'components/manage_user.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminService adminService = AdminService(); // Create an instance of AdminService
  int userCount = 0; // Variable to store the number of users
  int productCount = 0; // Variable to store the number of products
  List<dynamic> recentActivities = []; // Store recent activities
  bool isLoadingUsers = true; // State to track user loading
  bool isLoadingProducts = true; // State to track product loading
  bool isLoadingActivities = true; // State to track activity loading
  DateTime lastChecked = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchUserCount(); // Fetch the number of users on initialization
    _fetchProductCount(); // Fetch the number of products on initialization
    _fetchRecentActivities(); // Fetch recent activities on initialization
  }

  // Function to fetch the number of users
  Future<void> _fetchUserCount() async {
    try {
      final users = await adminService.getAllUsers();
      setState(() {
        userCount = users.length; // Assign fetched user count to userCount
        isLoadingUsers = false;   // Stop loading after fetching data
      });
    } catch (e) {
      print('Error fetching user count: $e');
      setState(() {
        isLoadingUsers = false;   // Stop loading in case of an error
      });
    }
  }

  // Function to fetch the number of products
  Future<void> _fetchProductCount() async {
    try {
      final products = await adminService.getAllProductsWithUserDetails();
      setState(() {
        productCount = products.length; // Set the product count
        isLoadingProducts = false; // Data loading complete
      });
    } catch (e) {
      print('Error fetching product count: $e');
      setState(() {
        isLoadingProducts = false; // Stop loading if there is an error
      });
    }
  }

  // Function to fetch recent activities
  Future<void> _fetchRecentActivities() async {
    try {
      final newUsers = await adminService.getNewUsers(lastChecked); // Fetch new users
      final newProducts = await adminService.getNewProducts(lastChecked); // Fetch new products
      setState(() {
        recentActivities = [
          ...newUsers.map((user) => 'New user signed up: ${user['name']}'),
          ...newProducts.map((product) => 'New product added: ${product['product_name']}')
        ];
        isLoadingActivities = false; // Stop loading after fetching
      });
    } catch (e) {
      print('Error fetching recent activities: $e');
      setState(() {
        isLoadingActivities = false; // Stop loading in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginInPage()),
              );
            },
          ),
        ],
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
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageUsersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageProductsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Admin!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: _buildStatCard('Users', isLoadingUsers ? 'Loading...' : '$userCount', Colors.blue),
                  ),
                  Flexible(
                    child: _buildStatCard('Products', isLoadingProducts ? 'Loading...' : '$productCount', Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              isLoadingActivities
                  ? const Center(child: CircularProgressIndicator()) // Show a loading spinner
                  : _buildActivityList(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create statistic cards
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentActivities.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.notifications, color: Colors.blue),
          title: Text(
            recentActivities[index],
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
