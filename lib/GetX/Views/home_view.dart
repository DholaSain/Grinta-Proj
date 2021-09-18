import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Bindings/all_bindings.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Views/categories_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: size.width * 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CategoriesView(),
                        binding: CategoriesBinding());
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MenuScreen(
                    //             // branchName: widget.branchName,
                    //             )));
                  },
                  child: Container(
                    width: size.width * 0.33,
                    height: size.width * 0.33,
                    decoration: BoxDecoration(
                      color: kGreyColor,
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(200),
                      ),
                    ),
                    child: const Center(
                        child: Text(
                      "Menu",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                )
              ],
            ),
          ),
        ));
  }
}
