import 'package:flutter/material.dart';
import 'package:weather/shared/image_upload.dart';
class ScreenTwo extends StatefulWidget {
  static const route2 = '/screen_two';
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('page two'),
      ),
      body: Column(
        children: [
          ImageUploadScreen(title: 'Upload Image',)
        ],
      ),
    );
  }
}
