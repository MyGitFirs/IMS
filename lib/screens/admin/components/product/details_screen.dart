import 'package:flutter/material.dart';

import '../../../../service/admin_service.dart'; // Import your service

class DetailsScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final double price;
  final String farmerName;
  final String dateAdded;
  final String status;
  final String imageUrl; // New parameter for the product image URL

  const DetailsScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.farmerName,
    required this.dateAdded,
    required this.status,
    required this.imageUrl, // Initialize the image URL
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String selectedStatus = '';
  final AdminService _adminService = AdminService(); // Initialize your service

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status; // Initialize with the current status
  }

  @override
  Widget build(BuildContext context) {
    bool isWebView = MediaQuery.of(context).size.width > 600; // Check for web view

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWebView ? 800 : double.infinity, // Limit width on larger screens
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the product image
                Center(
                  child: widget.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const SizedBox(
                    height: 200,
                    child: Center(child: Text('No Image Available')),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.productName,
                      style: TextStyle(
                        fontSize: isWebView ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedStatus,
                      items: ['approve', 'pending', 'denied']
                          .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status.toUpperCase()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _showConfirmationDialog(value);
                        }
                      },
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1.5),
                _buildDetailRow('Price', '₱${widget.price.toStringAsFixed(2)}'),
                _buildDetailRow('Farmer', widget.farmerName),
                _buildDetailRow('Date Added', widget.dateAdded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to show a confirmation dialog
  void _showConfirmationDialog(String newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you want to change the status to $newStatus?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                _updateStatus(newStatus); // Call the update service
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Method to call the update service
  Future<void> _updateStatus(String newStatus) async {
    try {
      await _adminService.updateProductStatus(widget.productId, newStatus);
      setState(() {
        selectedStatus = newStatus; // Update the status in the UI
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  // Helper widget to create detail rows
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approve':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'denied':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
