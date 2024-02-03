import 'package:flutter/material.dart';
import 'package:test_video_app/pages/home_page.dart';

void main() {
  runApp(const TestVideoApp());
}

class TestVideoApp extends StatelessWidget {
  const TestVideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
