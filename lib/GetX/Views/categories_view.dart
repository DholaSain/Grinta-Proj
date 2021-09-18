import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Bindings/all_bindings.dart';
import 'package:grinta/GetX/Controllers/categories_view_model.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Utils/global_variables.dart';
import 'package:grinta/GetX/Views/admin_login_view.dart';
import 'package:grinta/GetX/Views/products_view.dart';
import 'package:grinta/screen/admin_login.dart';
import 'package:grinta/screen/view_produect.dart';

class CategoriesView extends StatelessWidget {
  CategoriesView({Key? key}) : super(key: key);
  final controller = Get.find<CategoriesViewContrller>();
  final isGridView = false.obs;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: const Text(
          "Grinta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AdminLoginView());
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AdminLoginScreen(
              //               branchName: widget.branchName,
              //             )));
            },
            icon: const Icon(FontAwesome5.user_shield, size: 20),
          ),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.allCategories == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.allCategories!.length > 0) {
          // return Text(controller.allCategories!.first.name!);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.1,
                    decoration: const BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  isGridView.value = true;
                                },
                                icon: const Icon(MfgLabs.th_thumb, size: 22)),
                            IconButton(
                                onPressed: () {
                                  isGridView.value = false;
                                },
                                icon:
                                    const Icon(FontAwesome5.th_list, size: 22)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isGridView.value
                      ? GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 4 / 3.5,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6),
                          itemCount: controller.allCategories!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                categoryName.value =
                                    controller.allCategories![index].name!;
                                Get.to(() => ProductsView(),
                                    binding: ProductsBinding());
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ViewProduct(
                                //       branchName: widget.branchName,
                                //       categoryName: list[index]["category_name"]
                                //           .toString(),
                                //     ),
                                //   ),
                                // );
                              },
                              child: Container(
                                height: size.height * 0.20,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: kGreyColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 1.0,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(controller
                                          .allCategories![index].img!),
                                      fit: BoxFit.cover,
                                    )),
                                child: Text(
                                  controller.allCategories![index].name!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          })
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.allCategories!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                categoryName.value =
                                    controller.allCategories![index].name!;
                                Get.to(() => ProductsView(),
                                    binding: ProductsBinding());
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ViewProduct(
                                //       branchName: widget.branchName,
                                //       categoryName: list[index]["category_name"]
                                //           .toString(),
                                //     ),
                                //   ),
                                // );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.3,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    vertical: size.height * 0.008),
                                decoration: BoxDecoration(
                                    color: kGreyColor,
                                    border: Border.all(
                                        color: Colors.blueGrey, width: 1.0),
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        controller.allCategories![index].img!,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                                child: Text(
                                  controller.allCategories![index].name!,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                ],
              ),
            ),
          );
        } else {
          return const Center(
              child: Text('There are no Categories available.'));
        }
      }),
    );
  }
}
