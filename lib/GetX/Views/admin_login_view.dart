import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Views/admin_panel_view.dart';
import 'package:grinta/screen/admin_home.dart';
import 'package:grinta/screen/forget_password.dart';

class AdminLoginView extends StatelessWidget {
  AdminLoginView({Key? key}) : super(key: key);

  final isVisible = false.obs;
  final String _email = "grintacoffeeproject@gmail.com";
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: kBlackColor,
                automaticallyImplyLeading: false,
                toolbarHeight: 100,
                title: const Text(
                  "Grinta",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Entypo.cancel, size: 32),
                  ),
                  SizedBox(width: size.width * 0.02)
                ]),
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: const Text(
                      "Please enter the password to access Admin Panel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold))),
              SizedBox(height: size.height * 0.06),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                  child: Column(children: [
                    Obx(() => TextField(
                          obscureText: !isVisible.value,
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FontAwesome5.lock, size: 20),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    isVisible.value =
                                        isVisible.value ? false : true;
                                  },
                                  icon: Icon(
                                      isVisible.value
                                          ? FontAwesome5.eye_slash
                                          : FontAwesome5.eye,
                                      size: 14)),
                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.grey)),
                          controller: passwordController,
                        )),
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              _loginUser();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black87),
                            child: const Text("Admin Panel",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)))),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPassword()));
                        },
                        child: const Text("Forget your password?",
                            style: TextStyle(color: Colors.red)))
                  ]))
            ])));
  }

  void _loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email, password: passwordController.text);
      Get.to(() => const AdminPanelView());
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => AdminHome(
      //               branchName: widget.branchName,
      //             )),
      //     (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Get.snackbar('Error Loggingin', e.message.toString(),
            colorText: kWhiteColor,
            backgroundColor: kBlackColor,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
