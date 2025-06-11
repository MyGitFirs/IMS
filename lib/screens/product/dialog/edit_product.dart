import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../extra/image_picker.dart';
import '../../../service/product_service.dart';
import 'package:http/http.dart' as http;

class ProductEditScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductEditScreen({super.key, required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  late TextEditingController _stockQuantityController;

  Uint8List? selectedImage;
  String? uploadedImageUrl;
  String discountPrice = '0.00'; // Calculated discount price
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _descriptionController = TextEditingController(text: widget.product['description']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _stockQuantityController = TextEditingController(text: widget.product['quantity'].toString());// Initialize the discount price
  }



  Future<String?> uploadImageToCloudinary(Uint8List imageBytes) async {
    const cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dwe3p72ux/image/upload';
    const uploadPreset = 'flutter_upload_preset';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'upload.jpg'));
      request.fields['upload_preset'] = uploadPreset;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        return responseData['secure_url'];
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    if (selectedImage != null) {
      uploadedImageUrl = await uploadImageToCloudinary(selectedImage!);
    }

    final updatedProduct = {
      "name": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "price": double.parse(_priceController.text),
      "stock_quantity": int.tryParse(_stockQuantityController.text) ?? 0,
      "image_url": uploadedImageUrl ?? widget.product['image_url'],
    };

    try {
      final bool success = await _productService.updateProduct(
        widget.product['product_id'].toString(),
        updatedProduct,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update product')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: primaryColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          return Center(
            child: Container(
              width: isWideScreen ? 600 : double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text(
                      'Edit Product Details',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ImageUploadWidget(
                      onImageSelected: (imageBytes) {
                        setState(() {
                          selectedImage = imageBytes;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Product Image',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(_nameController, 'Name', TextInputType.text),
                    const SizedBox(height: 16),
                    _buildTextField(_descriptionController, 'Description', TextInputType.text),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _priceController,
                      'Price',
                      TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_stockQuantityController, 'Stock Quantity', TextInputType.number),
                    const SizedBox(height: 16),
                    const SizedBox(height: 32),
                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _updateProduct,
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType keyboardType,
      {String? Function(String?)? validator, void Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      ),
      keyboardType: keyboardType,
      validator: validator ?? (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      onChanged: onChanged,
    );
  }
}
