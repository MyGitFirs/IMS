import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../handlers/product_handler.dart';
import '../main/second_screen.dart';
import 'dialog/product_helper.dart';

Future<Map<String, String>?> showProductDialog(BuildContext context) async {
  String description = '';
  final ProductLayoutHelper layoutHelper = ProductLayoutHelper();
  bool isLoading = false; // Move loading state outside StatefulBuilder
  String? validationMessage; // Field for validation messages

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

  return await showDialog<Map<String, String>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          bool isMobile = MediaQuery.of(context).size.width < 600;

          return AlertDialog(
            title: const Text('Add new product'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loading spinner
                  : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (validationMessage != null) // Show validation message
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          validationMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    isMobile
                        ? Column(
                      children: layoutHelper.buildMobileLayout(setState),
                    )
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: layoutHelper.buildDesktopLayout(setState),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Describe if per piece, per box or other stuff.',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: isLoading
                    ? null // Disable Cancel while loading
                    : () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null // Disable Add button while loading
                    : () async {
                  // Validate required fields
                  if (layoutHelper.name.isEmpty ||
                      layoutHelper.price.isEmpty ||
                      layoutHelper.stock.isEmpty ||
                      layoutHelper.imageBytes == null ||
                      description.isEmpty) {
                    setState(() {
                      validationMessage = "Please fill out all forms, including uploading an image.";
                    });
                    return;
                  }

                  setState(() {
                    isLoading = true; // Start loading
                    validationMessage = null; // Clear validation message
                  });

                  String? imageUrl;
                  if (layoutHelper.imageBytes != null) {
                    imageUrl = await uploadImageToCloudinary(layoutHelper.imageBytes!);
                  }

                  bool success = await ProductHandler.addProductHandler(
                    context,
                    layoutHelper.name,
                    layoutHelper.price,
                    layoutHelper.stock,
                    description,
                    imageUrl,
                    
                  );

                  setState(() {
                    isLoading = false; // Stop loading
                  });

                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SecondScreen()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Failed to add product. Please try again.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const Text('Processing...') // Update button text while loading
                    : const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
