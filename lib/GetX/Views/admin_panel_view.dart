import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Bindings/all_bindings.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Views/categories_view.dart';
import 'package:grinta/GetX/Views/manage_branches_view.dart';
import 'package:grinta/GetX/Views/manage_categories_view.dart';
import 'package:grinta/screen/manage_categories.dart';
import 'package:grinta/screen/show_all_branches.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlackColor,
          automaticallyImplyLeading: false,
          title: const Text(
            "Grinta",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                _signOut();
              },
              icon: const Icon(FontAwesome.logout, size: 20),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: size.height * 0.1,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Admin Panel",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  height: size.height * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ManageBranchesView());
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ShowAllBranches()));
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black87),
                          child: const Text(
                            "Manage Branches",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ManageCategoriesView(),
                                binding: CategoriesBinding());
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ShowAllCategory()));
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black87),
                          child: Text(
                            "Manage Categories",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => AdminPanel(
                            //             branchName: widget.branchName)));
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black87),
                          child: Text(
                            "Manage Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.to(() => CategoriesView());
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => MenuScreen(branchName: widget.branchName)),
    //     (route) => false);
  }
}
