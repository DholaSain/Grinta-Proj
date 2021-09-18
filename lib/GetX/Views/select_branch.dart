import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Controllers/branch_selection_controller.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Utils/global_variables.dart';
import 'package:grinta/GetX/Views/home_view.dart';

class SelectBranch extends StatelessWidget {
  SelectBranch({Key? key}) : super(key: key);

  final branchSelectionController = Get.find<BranchSelectionController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: size.width * 0.5,
              ),
              Obx(
                () {
                  if (branchSelectionController.allBranchesNames!.isNotEmpty) {
                    List<String> bList = [];
                    for (int i = 0;
                        i < branchSelectionController.allBranchesNames!.length;
                        i++) {
                      bList.add(
                          branchSelectionController.allBranchesNames![i].name!);
                    }
                    return Column(
                      children: [
                        Container(
                          width: size.width * 0.6,
                          height: size.width * 0.12,
                          decoration: const BoxDecoration(
                            color: Color(0xffECECEC),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            items: bList,
                            label: branchSelectionController.label.value,
                            hint: "Select Your Branch",
                            onChanged: (value) {
                              branchSelectionController.label.value = value!;
                              menuBranch.value = value;
                              branchSelectionController.branchName.value =
                                  value == null ? "None" : value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.6,
                          height: size.width * 0.12,
                          child: ElevatedButton(
                            onPressed: () {
                              if (branchSelectionController.branchName.value !=
                                  "None") {
                                Get.to(() => const HomeView());
                                debugPrint(menuBranch.value);
                              } else {
                                Get.snackbar('Select Branch',
                                    'Please Select a Branch to proceed',
                                    colorText: kWhiteColor,
                                    backgroundColor: kBlackColor,
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black87),
                            child: const Text(
                              "Select",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
