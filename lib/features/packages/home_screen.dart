import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hajj & Umrah Packages'),
      ),
      body: const Center(
        child: Text('Packages will be listed here.'),
      ),
    );
  }
}
