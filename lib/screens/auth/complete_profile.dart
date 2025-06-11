import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';
import '../profile/views/gender_picker.dart';

class SelectShippingAddressScreen extends StatefulWidget {
  const SelectShippingAddressScreen({super.key});

  @override
  _SelectShippingAddressScreenState createState() => _SelectShippingAddressScreenState();
}

class _SelectShippingAddressScreenState extends State<SelectShippingAddressScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  String selectedGender = "Male";

  List<dynamic> regions = [];
  List<dynamic> provinces = [];
  List<dynamic> cities = [];
  List<dynamic> barangays = [];

  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;

  String? selectedRegionName;
  String? selectedProvinceName;
  String? selectedCityName;
  String? selectedBarangayName;

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/regions'));
    if (response.statusCode == 200) {
      setState(() {
        regions = json.decode(response.body);
      });
    }
  }

  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/provinces/$regionCode'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = json.decode(response.body);
      });
    }
  }

  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/cities/$provinceCode'));
    if (response.statusCode == 200) {
      setState(() {
        cities = json.decode(response.body);
      });
    }
  }

  Future<void> fetchBarangays(String cityCode) async {
    final response = await http.get(Uri.parse('$baseApiUrl/api/barangays/$cityCode'));
    if (response.statusCode == 200) {
      setState(() {
        barangays = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWideScreen ? 800 : 400),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Please fill in the information to complete Signup",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Fields
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.start,
                      children: [
                        _buildDropdownField(
                          label: "Region",
                          value: selectedRegion,
                          items: regions.map((region) {
                            return DropdownMenuItem(
                              value: region['code'].toString(),
                              child: Text(
                                region['name'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRegion = value;
                              selectedRegionName = regions.firstWhere((region) =>
                              region['code'].toString() == value)['name'];
                              selectedProvince = null;
                              selectedCity = null;
                              selectedBarangay = null;
                              provinces.clear();
                              cities.clear();
                              barangays.clear();
                            });
                            fetchProvinces(value!);
                          },
                        ),
                        _buildDropdownField(
                          label: "Province",
                          value: selectedProvince,
                          items: provinces.map((province) {
                            return DropdownMenuItem(
                              value: province['code'].toString(),
                              child: Text(
                                province['name'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProvince = value;
                              selectedProvinceName = provinces.firstWhere((province) =>
                              province['code'].toString() == value)['name'];
                              selectedCity = null;
                              selectedBarangay = null;
                              cities.clear();
                              barangays.clear();
                            });
                            fetchCities(value!);
                          },
                        ),
                        _buildDropdownField(
                          label: "City",
                          value: selectedCity,
                          items: cities.map((city) {
                            return DropdownMenuItem(
                              value: city['code'].toString(),
                              child: Text(
                                city['name'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                              selectedCityName = cities.firstWhere((city) =>
                              city['code'].toString() == value)['name'];
                              selectedBarangay = null;
                              barangays.clear();
                            });
                            fetchBarangays(value!);
                          },
                        ),
                        _buildDropdownField(
                          label: "Barangay",
                          value: selectedBarangay,
                          items: barangays.map((barangay) {
                            return DropdownMenuItem(
                              value: barangay['code'].toString(),
                              child: Text(
                                barangay['name'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBarangay = value;
                              selectedBarangayName = barangays.firstWhere((barangay) =>
                              barangay['code'].toString() == value)['name'];
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Other Fields
                    TextFormField(
                      controller: streetController,
                      decoration: const InputDecoration(
                        labelText: "Street No., Building, House No.",
                        prefixIcon: Icon(Icons.home_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10), // Max length 10 digits
                      ],
                    ),
                    const SizedBox(height: 20),
                    DateOfBirthPicker(controller: dateOfBirthController),
                    const SizedBox(height: 20),
                    GenderPicker(
                      selectedGender: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: _saveAddress,
                        child: const Text(
                          "Save Address",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // Apply input formatters
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
  void _saveAddress() {
    final phone = phoneController.text;
    final street = streetController.text.trim();
    final barangay = selectedBarangayName?.trim() ?? '';
    final city = selectedCityName?.trim() ?? '';
    final province = selectedProvinceName?.trim() ?? '';
    final region = selectedRegionName?.trim() ?? '';
    final dateOfBirth = dateOfBirthController.text;
    final gender = selectedGender;

    if (street.isEmpty || barangay.isEmpty || city.isEmpty || province.isEmpty || region.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all address fields')),
      );
      return;
    }

    final address = "$street, $barangay, $city, $province, $region".trim();

    Navigator.pop(context, {
      'phoneNumber': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    });
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: 300, // Set a fixed width for dropdown fields
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        value: value,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
class DateOfBirthPicker extends StatelessWidget {
  final TextEditingController controller;

  const DateOfBirthPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Date of Birth",
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        final currentDate = DateTime.now();
        final maxDate = DateTime(currentDate.year - 18, currentDate.month, currentDate.day);
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: maxDate, // Default to 18 years ago
          firstDate: DateTime(1900), // Earliest selectable date
          lastDate: maxDate, // Latest selectable date
        );
        if (selectedDate != null) {
          controller.text = "${selectedDate.toLocal()}".split(' ')[0];
        }
      },
    );
  }
}

