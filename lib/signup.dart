import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'login.dart';
import 'phone_input.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "/signup";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  DateTime? _dob;
  String _gender = "";
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void msg(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s)),
    );
  }

  bool validate() {
    if (_name.text.trim().isEmpty) {
      msg("Enter full name");
      return false;
    }

    if (_mobile.text.trim().length < 10) {
      msg("Enter valid mobile number");
      return false;
    }

    if (!_email.text.contains("@")) {
      msg("Enter valid email");
      return false;
    }

    if (_password.text.length < 6) {
      msg("Password must be at least 6 characters");
      return false;
    }

    if (_dob == null) {
      msg("Select Date of Birth");
      return false;
    }

    if (_gender.isEmpty) {
      msg("Select gender");
      return false;
    }

    return true;
  }

  Future<void> signup() async {
    if (!validate()) return;

    AuthController.to.signup(
      _email.text.trim(),
      _password.text.trim(),
    );
  }

  InputDecoration field(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f2ff),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Signup"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(controller: _name, decoration: field("Full Name")),
            const SizedBox(height: 12),

            TextField(
              controller: _mobile,
              keyboardType: TextInputType.number,
              decoration: field("Mobile Number"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: field("Email"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _password,
              obscureText: true,
              decoration: field("Password"),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  _dob == null
                      ? "DOB: Not selected"
                      : "DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}",
                  style: const TextStyle(fontSize: 15),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _dob = picked);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Pick DOB"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Text("Gender:", style: TextStyle(fontSize: 16)),
                Radio(
                  value: "Male",
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v!),
                ),
                const Text("Male"),
                Radio(
                  value: "Female",
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v!),
                ),
                const Text("Female"),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Get.offNamed(LoginScreen.routeName),
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),

            TextButton(
              onPressed: () => Get.toNamed(PhoneInputScreen.routeName),
              child: const Text(
                "Or Login with Phone Number",
                style: TextStyle(color: Colors.deepPurple),
              ),
            )
          ],
        ),
      ),
    );
  }
}
