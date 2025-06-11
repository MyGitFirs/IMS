import 'package:flutter/material.dart';
import 'order_details_screen.dart';

class OrderBox extends StatelessWidget {
  final int orderId;
  final double totalAmount;
  final String status;
  final VoidCallback onOrderUpdated;
  const OrderBox({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.status,
    required this.onOrderUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(orderId: orderId),
          ),
        ).then((_) {
          onOrderUpdated();
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if the available width is greater than 600 pixels (desktop)
              bool isDesktop = constraints.maxWidth > 600;

              if (isDesktop) {
                // Horizontal layout for desktop
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Amount: ₱${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Status: $status',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              } else {
                // Vertical layout for mobile
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Amount: ₱${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Status: $status',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
