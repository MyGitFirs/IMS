import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class UserBox extends StatelessWidget {
  final String userName;
  final String userRole;
  final String joinDate;
  final VoidCallback onTap;

  const UserBox({super.key, 
    required this.userName,
    required this.userRole,
    required this.joinDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format the joinDate string to show only the date and 12-hour time
    String formattedDate = _formatDate(joinDate);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if the available width is greater than 600 pixels for web view
              bool isWebView = constraints.maxWidth > 600;

              return isWebView
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User Name
                  Expanded(
                    flex: 2,
                    child: Text(
                      userName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16), // Space between elements

                  // User Role
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Role: $userRole',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  const SizedBox(width: 16), // Space between elements

                  // Join Date
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Joined: $formattedDate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),

                  // User Role
                  Text(
                    'Role: $userRole',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),

                  // Join Date
                  Text(
                    'Joined: $formattedDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to format the joinDate
  String _formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime); // Format to 12-hour time
    } catch (e) {
      print('Error parsing date: $e');
      return dateString; // Return the original string if parsing fails
    }
  }
}
