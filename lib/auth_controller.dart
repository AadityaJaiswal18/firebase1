import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var loading = false.obs;
  var phoneLoading = false.obs;
  var verificationId = "".obs;
  int? _resendToken;

  @override
  void onReady() {
    super.onReady();

    getFcmToken();

    _auth.userChanges().listen((User? user) {
      if (user == null) {
        Get.offAllNamed("/login");
      } else {
        Get.offAllNamed("/dashboard");
      }
    });
  }

  Future<void> getFcmToken() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    String? token = await fcm.getToken();
    print("FCM TOKEN: $token");
  }

  void showMsg(String msg) {
    Get.snackbar("Info", msg);
  }

  Future<void> signup(String email, String pass) async {
    loading.value = true;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      showMsg("Account Created Successfully");
    } on FirebaseAuthException catch (e) {
      showMsg(e.message ?? "Signup Error");
    }
    loading.value = false;
  }

  Future<void> loginEmail(String email, String pass) async {
    loading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      showMsg("Login Successful");
    } on FirebaseAuthException catch (e) {
      showMsg(e.message ?? "Login Error");
    }
    loading.value = false;
  }

  Future<void> loginGoogle() async {
    try {
      final GoogleSignInAccount? user = await GoogleSignIn().signIn();
      if (user == null) return;
      final googleAuth = await user.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _auth.signInWithCredential(cred);
      showMsg("Google Login Successful");
    } catch (e) {
      showMsg(e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPhoneOtp(String phone) async {
    phoneLoading.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            showMsg("Phone automatically verified & user signed in");
          } catch (e) {
            showMsg("Auto sign-in failed: ${e.toString()}");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          showMsg(e.message ?? "Phone verification failed");
          phoneLoading.value = false;
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          _resendToken = resendToken;
          phoneLoading.value = false;
          Get.toNamed("/otp");
          showMsg("OTP sent to $phone");
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
          phoneLoading.value = false;
        },
      );
    } catch (e) {
      phoneLoading.value = false;
      showMsg(e.toString());
    }
  }

  Future<void> verifyPhoneOtp(String smsCode) async {
    phoneLoading.value = true;
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(cred);
      showMsg("Phone verification successful");
    } on FirebaseAuthException catch (e) {
      showMsg(e.message ?? "OTP verification failed");
    } catch (e) {
      showMsg(e.toString());
    }
    phoneLoading.value = false;
  }

  Future<void> resendPhoneOtp(String phone) async {
    await sendPhoneOtp(phone);
  }
}
