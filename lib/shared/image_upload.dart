import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  final String title;
  final Function(String)? onUploadComplete;
  const ImageUploadScreen({super.key, required this.title, this.onUploadComplete});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _downloadUrl; // To store the download URL

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _uploadImage(); // Automatically upload after image selection
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> _uploadImage() async {
    try {
      print('test');
      if (_image == null) return;

      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      debugPrint('file name is $firebaseStorageRef');
      SettableMetadata metadata = SettableMetadata(contentType: 'image/png');
      /// if there is any problem to upload image after your code is ok but image not store on firebase storeage
      UploadTask uploadTask = firebaseStorageRef.putFile(_image!, metadata);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _downloadUrl = downloadUrl;
      });

      if (widget.onUploadComplete != null) {
        widget.onUploadComplete!(_downloadUrl!);
      }
    } on Exception catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _deleteImage() {
    setState(() {
      _image = null;
      _downloadUrl = null; // Clear download URL when deleting the image
    });
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose image source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: _showImageSourceDialog,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Stack(
            children: [
              if (_image == null)
                Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              if (_image != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _deleteImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
