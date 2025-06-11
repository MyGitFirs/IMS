import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class ProductBox extends StatelessWidget {
  final String productName;
  final double price;
  final String farmerName;
  final String dateAdded;
  final String status;

  const ProductBox({super.key, 
    required this.productName,
    required this.price,
    required this.farmerName,
    required this.dateAdded,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Format the dateAdded string to show only the date and 12-hour time
    String formattedDate = _formatDate(dateAdded);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Smooth rounded corners
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Adjust card margins
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding for a cleaner layout
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWebView = constraints.maxWidth > 600; // Check for web view

            // Responsive layout: Row for web and Column for smaller screens
            return isWebView
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Farmer: $farmerName',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700], // Softer color tone
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date Added: $formattedDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16), // Space between columns
                // Right side content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Align to the right
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₱${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8), // Space before status
                // Status label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toUpperCase(), // Uppercase for emphasis
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farmer: $farmerName',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700], // Softer color tone
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date Added: $formattedDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toUpperCase(), // Uppercase for emphasis
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper method to format the date
  String _formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime); // Format to 12-hour time
    } catch (e) {
      print('Error parsing date: $e');
      return dateString; // Return the original string if parsing fails
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approve':
        return Colors.green;
      case 'pending':
        return Colors.amber; // Changed to amber for better visibility
      case 'denied':
        return Colors.red;
      default:
        return Colors.black; // Default color
    }
  }
}
