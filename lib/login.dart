import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void msg(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s)),
    );
  }

  Future<void> loginEmail() async {
    if (!_email.text.contains("@")) return msg("Enter valid email");
    if (_password.text.length < 6) return msg("Password must be 6+ chars");

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      msg("Login Successful ✔");
    } on FirebaseAuthException catch (e) {
      msg(e.message ?? e.code);
    }

    setState(() => _loading = false);
  }

  Future<void> loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      msg("Google Login Successful ✔");
    } catch (e) {
      msg(e.toString());
    }
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
        title: const Text("Login"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            TextField(controller: _email, decoration: field("Email")),
            const SizedBox(height: 15),

            TextField(
              controller: _password,
              obscureText: true,
              decoration: field("Password"),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: _loading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              )
                  : ElevatedButton(
                onPressed: loginEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            InkWell(
              onTap: loginGoogle,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://th.bing.com/th/id/OIP.u-Oj5cReHJfTZTzavM6DZwAAAA?w=180&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
                      height: 26,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, SignupScreen.routeName);
              },
              child: const Text(
                "Don’t have an account? Signup",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
