import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Utils/colors.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  final String _email = "grintacoffeeproject@gmail.com";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: const Text(
          "Grinta",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.04),
                  child: const Text(
                    "Forget Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                const Text(
                  "App Licence Code",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.04),
                  child: Center(
                    child: Text(
                      "grintacoffeeproject@gmail.com".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Center(
                  child: SizedBox(
                    height: 40,
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        _resetPassword();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                      ),
                      child: const Text(
                        "Sent Reset Link",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.sendPasswordResetEmail(email: _email);
    Get.snackbar(
      'Password Reset',
      'Recovery email has been sent!',
      backgroundColor: kBlackColor,
      colorText: kWhiteColor,
    );
  }
}
