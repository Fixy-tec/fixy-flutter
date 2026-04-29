import 'package:flutter/material.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      body: const Center(child: Text('Mis solicitudes - Sprint 4')),
    );
  }
}
