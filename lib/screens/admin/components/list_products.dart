import 'package:flutter/material.dart';
import '../../../service/admin_service.dart';
import '../admin_screen.dart';
import 'manage_user.dart';
import 'product/details_screen.dart';
import 'product/product_box.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final AdminService adminService = AdminService(); // Create an instance of AdminService
  List<Map<String, dynamic>> products = []; // Products fetched from the API
  List<Map<String, dynamic>> filteredProducts = [];
  String? selectedStatus;
  bool isLoading = true; // State to track loading

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products on initialization
  }

  // Function to fetch products from the API
  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await adminService.getAllProductsWithUserDetails();
      setState(() {
        products = List<Map<String, dynamic>>.from(fetchedProducts);
        filteredProducts = List.from(products); // Initialize filtered products
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false; // Stop loading if there is an error
      });
    }
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        bool statusMatch = selectedStatus == null || product['status'] == selectedStatus;
        return statusMatch;
      }).toList();
    });
  }

  void _cancelStatusFilter() {
    setState(() {
      selectedStatus = null; // Reset the selected status
      filteredProducts = List.from(products); // Reset to all products
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageUsersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: const Text('Filter by Status'),
                  value: selectedStatus,
                  items: <String>['approve', 'pending', 'denied']
                      .map((status) => DropdownMenuItem<String>(
                    value: status,
                    child: Text(status.capitalize()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                      _filterProducts();
                    });
                  },
                ),
                if (selectedStatus != null)
                  TextButton(
                    onPressed: _cancelStatusFilter,
                    child: const Text('X Cancel Filter', style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            productId: filteredProducts[index]['product_id'],
                            imageUrl: filteredProducts[index]['image_url'],
                            productName: filteredProducts[index]['product_name'],
                            price: filteredProducts[index]['price'],
                            farmerName: filteredProducts[index]['user_name'],
                            dateAdded: filteredProducts[index]['created_at'],
                            status: filteredProducts[index]['status'] ?? 'pending',
                          ),
                        ),
                      ).then((_) {
                        // Reload the products when returning from DetailsScreen
                        _fetchProducts();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ProductBox(
                        productName: filteredProducts[index]['product_name'],
                        price: filteredProducts[index]['price'],
                        farmerName: filteredProducts[index]['user_name'],
                        dateAdded: filteredProducts[index]['created_at'],
                        status: filteredProducts[index]['status']??'pending',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
