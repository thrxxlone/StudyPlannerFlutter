import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ScheduleScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: const Center(
        child: Text(
          "Schedule Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
