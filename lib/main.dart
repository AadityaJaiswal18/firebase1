import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'signup.dart';
import 'login.dart';
import 'dashboard.dart';
import 'auth_controller.dart';

import 'phone_input.dart';
import 'otp_verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      getPages: [
        GetPage(name: SignupScreen.routeName, page: () => const SignupScreen()),
        GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
        GetPage(name: DashboardScreen.routeName, page: () => const DashboardScreen()),
        GetPage(name: PhoneInputScreen.routeName, page: () => const PhoneInputScreen()),
        GetPage(name: OtpVerifyScreen.routeName, page: () => const OtpVerifyScreen()),
      ],
    );
  }
}
