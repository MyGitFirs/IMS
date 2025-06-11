import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/recent_sales.dart';

class OrderService {

  final String baseUrl = '$baseApiUrl/api/order';
  // Fetch orders (for Admin Farmer)
  Future<List<dynamic>> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final url = Uri.parse('$baseUrl/pending/$userId'); // Include user_id in the URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders');
    }
  }


  // Update order status
  Future<void> updateOrderStatus(int orderId, String status) async {
    final url = Uri.parse('$baseUrl/$orderId/status');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }
  }
  Future<Map<String, dynamic>> fetchOrderWithItems(int orderId) async {
    final response = await http.get(Uri.parse('$baseUrl/orders/$orderId'));
    print(orderId);
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }
  Future<List<RecentTransaction>> fetchRecentSales() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final response = await http.get(
        Uri.parse('$baseApiUrl/api/sales/recent-sales/$userId'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) =>
          RecentTransaction(
            icon: "assets/icons/sale_icon.svg", // Path to your icon asset
            title: json['productName'],
            date: json['saleDate'],
            quantity: json['quantitySold'].toString(),
          )).toList();
    } else {
      throw Exception("Failed to load recent sales");
    }
  }
}
