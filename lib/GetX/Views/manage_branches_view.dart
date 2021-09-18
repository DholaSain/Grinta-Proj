import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Controllers/branch_selection_controller.dart';
import 'package:grinta/GetX/Services/database_service.dart';
import 'package:grinta/GetX/Utils/colors.dart';

class ManageBranchesView extends StatelessWidget {
  ManageBranchesView({Key? key}) : super(key: key);

  final controllerB = Get.find<BranchSelectionController>();
  final TextEditingController textController = TextEditingController();
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
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kGreyColor,
                ),
                padding: const EdgeInsets.only(left: 15, right: 0),
                child: TextFormField(
                  controller: textController,
                  cursorColor: kBlackColor,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: kBlackColor,
                    hintText: 'New Branch Name',
                    hintStyle: TextStyle(fontSize: 13, color: kBlackColor),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              MaterialButton(
                color: kBlackColor,
                padding: const EdgeInsets.all(0),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '+ Add New Branch ',
                    style: TextStyle(color: kWhiteColor),
                  ),
                ),
                onPressed: () async {
                  if (textController.text != '') {
                    await Database().addBranch(textController.text);
                    textController.clear();
                  } else {
                    Get.snackbar(
                        'Branch Name Required', 'Type branch name first.',
                        colorText: kWhiteColor);
                  }
                },
              ),
              Container(
                height: size.height * 0.1,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  "Manage Branches",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: size.height * 0.64,
                width: double.infinity,
                child: Obx(() {
                  if (controllerB.allBranchesNames == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controllerB.allBranchesNames!.length > 0) {
                    return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: controllerB.allBranchesNames!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kGreyColor,
                            ),
                            child: ListTile(
                              title: Text(
                                controllerB.allBranchesNames![index].name!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: kRedColor,
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                      title: 'Delete Branch?',
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Do you realy want to delete the ${controllerB.allBranchesNames![index].name!}?',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'If you delete this branch!\nAll the relevent data will also be deleted including categories & products',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      textConfirm: 'Delete',
                                      textCancel: 'Cancel',
                                      buttonColor: kBlackColor,
                                      confirmTextColor: kWhiteColor,
                                      cancelTextColor: kBlackColor,
                                      onConfirm: () async {
                                        await Database().deleteBranch(
                                          controllerB
                                              .allBranchesNames![index].name!,
                                        );
                                      });
                                },
                              ),
                            ),
                          );
                          // return Center(
                          //   child: Container(
                          //     height: size.height * 0.16,
                          //     margin: EdgeInsets.all(size.height * 0.007),
                          //     alignment: Alignment.bottomLeft,
                          //     decoration: BoxDecoration(
                          //         color: Colors.grey,
                          //         border: Border.all(
                          //           color: Colors.blueGrey,
                          //           width: 1.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(10)),
                          //     child: Container(
                          //       height: size.height * 0.16,
                          //       decoration: const BoxDecoration(
                          //           borderRadius: BorderRadius.only(
                          //               bottomLeft: Radius.circular(10),
                          //               bottomRight: Radius.circular(10))),
                          //       padding: EdgeInsets.only(
                          //         left: size.width * 0.04,
                          //         right: size.width * 0.04,
                          //       ),
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.end,
                          //             children: [
                          //               SingleChildScrollView(
                          //                 scrollDirection: Axis.vertical,
                          //                 child: Text(
                          //                   controllerB
                          //                       .allBranchesNames![index].name!,
                          //                   style: TextStyle(
                          //                       fontSize: 20,
                          //                       color: Colors.white,
                          //                       fontWeight: FontWeight.bold),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           GestureDetector(
                          //             behavior: HitTestBehavior.deferToChild,
                          //             child: Container(
                          //               margin: EdgeInsets.only(
                          //                   top: size.height * 0.01),
                          //               padding: EdgeInsets.symmetric(
                          //                   vertical: size.height * 0.01),
                          //               decoration: const BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius: BorderRadius.only(
                          //                     topRight: Radius.circular(50),
                          //                     topLeft: Radius.circular(50)),
                          //               ),
                          //               child: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 children: [
                          //                   Icon(
                          //                     FontAwesome5.trash,
                          //                     color: Colors.red,
                          //                     size: size.height * 0.04,
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //             onTap: () {
                          // querySnapshot.data!.docs
                          //     .forEach((doc) {
                          //   if (list[index]
                          //           ["branch_name"] ==
                          //       doc["branch_name"]) {
                          //     FirebaseFirestore.instance
                          //         .collection(
                          //             'branches')
                          //         .doc(doc.id)
                          //         .delete()
                          //         .then((value) => print(
                          //             "User Deleted"))
                          //         .catchError((error) =>
                          //             print(
                          //                 "Failed to delete user: $error"));
                          //     print(doc["branch_name"]);
                          // }
                          // });
                          //               var snackBar = const SnackBar(
                          //                   content: Text(
                          //                       'Branch Deleted Successfully'));
                          //               ScaffoldMessenger.of(context)
                          //                   .showSnackBar(snackBar);
                          //             },
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                        });
                  } else {
                    return const Center(child: Text('No Branches Available.'));
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
