import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Controllers/categories_view_model.dart';
import 'package:grinta/GetX/Services/database_service.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Utils/global_variables.dart';
import 'package:grinta/GetX/Views/add_category.dart';
import 'package:grinta/GetX/Views/admin_panel_view.dart';

class ManageCategoriesView extends StatelessWidget {
  ManageCategoriesView({Key? key}) : super(key: key);
  final cController = Get.find<CategoriesViewContrller>();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                'All Categories of ${menuBranch.value}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: cController.allCategories!.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 100,
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
                                    cController.allCategories![index].img!,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                            child: Text(
                              cController.allCategories![index].name!,
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            Get.defaultDialog(
                                title: 'Delete Category?',
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        'Do you realy want to delete the ${cController.allCategories![index].name!}?',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Text(
                                        'If you delete this Category!\nAll the relevent data will also be deleted including products',
                                        textAlign: TextAlign.center)
                                  ],
                                ),
                                textConfirm: 'Delete',
                                textCancel: 'Cancel',
                                buttonColor: kBlackColor,
                                confirmTextColor: kWhiteColor,
                                cancelTextColor: kBlackColor,
                                onConfirm: () async {
                                  try {
                                    await Database().deleteCategory(cController
                                        .allCategories![index].name!);
                                    Get.snackbar('Category Deleted',
                                        "Category Deleted Sucessfully.",
                                        backgroundColor: kBlackColor,
                                        colorText: kWhiteColor,
                                        snackPosition: SnackPosition.BOTTOM);
                                    Get.back();
                                    Get.off(() => const AdminPanelView());
                                  } catch (e) {
                                    Get.snackbar('Error', e.toString(),
                                        backgroundColor: kBlackColor,
                                        colorText: kRedColor,
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: kRedColor,
                          ),
                        ),
                      ],
                    );
                  }),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.off(() => AddCategoryView());
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.black87),
                  child: const Text(
                    "+ Add New Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
