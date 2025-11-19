import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class PhoneInputScreen extends StatefulWidget {
  static const routeName = "/phone";
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      labelText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f2ff),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Phone Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: inputStyle("Enter phone number (with country code)"),
            ),

            const SizedBox(height: 20),

            Obx(() {
              return SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: AuthController.to.phoneLoading.value
                      ? null
                      : () {
                    AuthController.to.sendPhoneOtp(_phone.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: AuthController.to.phoneLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Send OTP",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Get.offAllNamed("/login");
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(color: Colors.deepPurple),
              ),
            )
          ],
        ),
      ),
    );
  }
}
