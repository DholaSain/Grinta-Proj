import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Views/select_branch.dart';
import 'package:grinta/screen/branch_selection.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Grinta Coffee",
      home: SplashScreenView(
        navigateRoute: SelectBranch(),
        duration: 3000,
        imageSize: 200,
        imageSrc: "assets/images/logo.png",
        backgroundColor: Colors.white,
      ),
    );
  }
}
