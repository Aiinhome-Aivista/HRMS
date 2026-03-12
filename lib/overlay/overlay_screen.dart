import 'package:flutter/material.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue,
          child: const Text("hello")
        ),
      ),
    );
  }
}