import 'package:flutter/material.dart';
import 'package:flutter_application_1/responsive.dart';

import '../../constants.dart';
import '../../service/order_service.dart';
import '../dashboard/components/header.dart';
import 'dialog/order_box.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(), // Custom header widget
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5, // Takes most of the space
                  child: Column(
                    children: [
                      const Text(
                        "Orders",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      // Orders List Widget
                      const OrderList(), // Custom widget to show list of orders
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // You can add any extra widgets for larger screens here if needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom OrderList widget to display the list of orders
class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final OrderService orderService = OrderService();
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      List<dynamic> fetchedOrders = await orderService.fetchOrders();
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true, // Ensures the ListView takes minimal space
      physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderBox(
          orderId: order['order_id'],
          totalAmount: order['totalAmount'],
          status: order['orderStatus'],
          onOrderUpdated: _fetchOrders,
        );
      },
    );
  }
}
