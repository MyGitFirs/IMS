import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../extra/image_picker.dart';
import 'date_formater.dart';
  // Ensure you import necessary dependencies

class ProductLayoutHelper {
  String name = '';
  String price = '';
  String stock = '';
  Uint8List? imageBytes;

  List<Widget> buildMobileLayout(StateSetter setState) {
    return [
      _buildProductDetailsColumn(setState),
      const SizedBox(height: 16.0),
      ImageUploadWidget(
        onImageSelected: (Uint8List imageData) {
          setState(() {
            imageBytes = imageData;
          });
        },
      ),
    ];
  }

  List<Widget> buildDesktopLayout(StateSetter setState) {
    return [
      Expanded(
        flex: 2,
        child: _buildProductDetailsColumn(setState),
      ),
      const SizedBox(width: 24.0),
      Expanded(
        flex: 1,
        child: ImageUploadWidget(
          onImageSelected: (Uint8List imageData) {
            setState(() {
              imageBytes = imageData;
            });
          },
        ),
      ),
    ];
  }

  Widget _buildProductDetailsColumn(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Product Name',
            ),
            onChanged: (value) {
              name = value;
            },
          ),
        ),
        Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Price (₱)',
                    prefixText: '₱',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    price = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    stock = value;
                  },
                ),
              ),
      ],
    );
  }
}
