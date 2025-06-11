import 'package:flutter/material.dart';
import '../../../service/order_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderService orderService = OrderService();
  Map<String, dynamic>? orderDetails;
  bool isLoading = true;
  String? selectedStatus;

  final Map<String, IconData> statusIcons = {
    'Pending': Icons.hourglass_empty,
    'Confirmed': Icons.check_circle_outline,
    'Out for Delivery': Icons.local_shipping,
    'Delivered': Icons.done_all,
  };

  final Map<String, Color> statusColors = {
    'Pending': Colors.orange,
    'Confirmed': Colors.blue,
    'Out for Delivery': Colors.amber,
    'Delivered': Colors.green,
  };

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _updateOrderStatus(int orderId, String status) async {
    try {
      await orderService.updateOrderStatus(orderId, status);
      _fetchOrderDetails(); // Refresh the details after status update
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final response = await orderService.fetchOrderWithItems(widget.orderId);
      if (response['success']) {
        setState(() {
          orderDetails = response['order'];
          selectedStatus = orderDetails!['orderStatus'];
          isLoading = false;
        });
      } else {
        setState(() {
          orderDetails = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        orderDetails = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderDetails == null
          ? const Center(child: Text('Order not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Information',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Text(
                      'Name: ${orderDetails!['customer_name']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Contact: ${orderDetails!['customer_contact']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Address: ${orderDetails!['customer_address']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Text(
                      'Order ID: ${orderDetails!['order_id']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Total Amount: ₱${orderDetails!['totalAmount']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          statusIcons[selectedStatus!] ??
                              Icons.info_outline,
                          color: statusColors[selectedStatus!] ??
                              Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedStatus ?? 'Unknown',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: selectedStatus == 'Delivered'
                              ? null
                              : () {
                            final statuses = [
                              'Pending',
                              'Confirmed',
                              'Out for Delivery',
                              'Delivered'
                            ];
                            final currentIndex = statuses
                                .indexOf(selectedStatus!);
                            final nextStatus = statuses[
                            (currentIndex + 1).clamp(
                                0, statuses.length - 1)];

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Confirm Status Update'),
                                  content: Text(
                                      'Are you sure you want to update the status to "$nextStatus"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context)
                                              .pop(),
                                      child: const Text(
                                          'Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedStatus =
                                              nextStatus;
                                        });
                                        _updateOrderStatus(
                                            widget.orderId,
                                            nextStatus);
                                        Navigator.of(context)
                                            .pop();
                                      },
                                      child: const Text(
                                          'Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedStatus ==
                                'Delivered'
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                          ),
                          child: const Text('Update Status'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Items',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: orderDetails!['items'] != null &&
                  orderDetails!['items'].isNotEmpty
                  ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderDetails!['items'].length,
                itemBuilder: (context, index) {
                  final item = orderDetails!['items'][index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['product_name'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                fontWeight:
                                FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${item['quantity']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                          ),
                          Text(
                            'Price: ₱${item['price']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No items found',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
