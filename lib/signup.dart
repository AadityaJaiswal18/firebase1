import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

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

  void _showMsg(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s)),
    );
  }

  bool _validateInputs() {
    if (_name.text.trim().isEmpty) {
      _showMsg("Enter full name");
      return false;
    }

    if (_mobile.text.trim().length < 10) {
      _showMsg("Enter valid mobile");
      return false;
    }

    if (!_email.text.contains("@")) {
      _showMsg("Invalid email");
      return false;
    }

    if (_password.text.length < 6) {
      _showMsg("Password must be 6+ chars");
      return false;
    }

    if (_dob == null) {
      _showMsg("Select Date of Birth");
      return false;
    }

    if (_gender.isEmpty) {
      _showMsg("Select gender");
      return false;
    }

    return true;
  }

  Future<void> _signup() async {
    if (!_validateInputs()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );

      _showMsg("Account Created Successfully ✔");

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } on FirebaseAuthException catch (e) {
      _showMsg(e.message ?? e.code);
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f2ff),

      appBar: AppBar(
        title: const Text("Signup"),
        backgroundColor: Colors.deepPurple,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            TextField(controller: _name, decoration: _dec("Full Name")),
            const SizedBox(height: 12),

            TextField(
              controller: _mobile,
              keyboardType: TextInputType.number,
              decoration: _dec("Mobile Number"),
            ),
            const SizedBox(height: 12),

            // EMAIL
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec("Email"),
            ),
            const SizedBox(height: 12),

            // PASSWORD
            TextField(
              controller: _password,
              obscureText: true,
              decoration: _dec("Password"),
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
                    backgroundColor: Colors.black,   // BLACK
                    foregroundColor: Colors.white,   // WHITE TEXT
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
              child: _loading
                  ? const Center(
                child: CircularProgressIndicator(
                    color: Colors.deepPurple),
              )
                  : ElevatedButton(
                onPressed: _signup,
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
              onPressed: () => Navigator.pushReplacementNamed(
                  context, LoginScreen.routeName),
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
