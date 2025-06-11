import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart'; // Ensure this package is added to pubspec.yaml

class ImageUploadWidget extends StatefulWidget {
  final Function(Uint8List)? onImageSelected; // Callback to return image data

  const ImageUploadWidget({super.key, this.onImageSelected});

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  Uint8List? imageData;

  // Function to pick image and return the data without uploading
  Future<void> pickImage() async {
    final data = await ImagePickerWeb.getImageAsBytes(); // Picking the image as bytes
    if (data != null) {
      setState(() {
        imageData = data;
      });
      // Notify parent widget of the selected image data
      widget.onImageSelected?.call(data);
    }
  }

  // Function to cancel the image selection
  void cancelImageSelection() {
    setState(() {
      imageData = null; // Clear the image data
    });

    // Notify the parent widget if a callback is provided
    widget.onImageSelected?.call(Uint8List(0)); // Send an empty Uint8List
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: imageData != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.memory(
                      imageData!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(
                    Icons.add_a_photo,
                    color: Colors.grey,
                  ),
                ),
              ),
              if (imageData != null)
                Positioned(
                  right: 5,
                  top: 5,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: cancelImageSelection, // Call cancel function
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text('Upload Image'), // Static text as upload occurs later
        ],
      ),
    );
  }
}
