import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthController.to.logout();
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to Dashboard",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
