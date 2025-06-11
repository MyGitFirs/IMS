import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';

class AddressService {
  final String baseUrl = '$baseApiUrl/api/address';


  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<List<Map<String, dynamic>>> getAddressByUserId() async {
    final userId = await _getUserId(); // Fetch userId here
    if (userId == null) {
      print('User ID not found');
      return [];
    }

    final response = await http.get(Uri.parse('$baseUrl/get_user/$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Check if data is a list or single item and return accordingly
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data is Map<String, dynamic>) {
        return [data]; // Wrap in a list if it's a single map
      }
    } else if (response.statusCode == 404) {
      print('Address not found for this user');
    } else {
      print('Failed to fetch address by user_id');
    }

    return [];
  }
  Future<void> deleteAddressById(int addressId) async {
    print('my address: $addressId');
    final url = Uri.parse('$baseUrl/delete/$addressId');

    try {
      final response = await http.delete(url);
      print(response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }
  // Update address by user_id
  Future<bool> updateAddressByUserId(String name, String address, String phone, bool isDefault) async {
    final userId = await _getUserId(); // Fetch userId here
    if (userId == null) {
      print('User ID not found');
      return false;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/update/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'label': 'sample',
      }),
    );

    if (response.statusCode == 200) {
      print('Address updated successfully');
      return true;
    } else if (response.statusCode == 404) {
      print('Address not found for this user');
      return false;
    } else {
      print('Failed to update address by user_id');
      return false;
    }
  }

  // Add address by user_id
  Future<bool> addAddressByUserId(String name, String address, String phone) async {
    final userId = await _getUserId(); // Fetch userId here
    if (userId == null) {
      print('User ID not found');
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/add/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'phone': phone,
        'label': 'sample',
      }),
    );

    if (response.statusCode == 201) {
      print('Address added successfully');
      return true;
    } else {
      print('Failed to add address for this user');
      return false;
    }
  }
}
