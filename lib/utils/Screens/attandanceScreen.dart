import 'package:flutter/material.dart';

class Attandancescreen extends StatefulWidget {
  const Attandancescreen({super.key});

  @override
  State<Attandancescreen> createState() => _AttandancescreenState();
}

class _AttandancescreenState extends State<Attandancescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATTENDANCE SEREEN'),
      ),
    );
  }
}
