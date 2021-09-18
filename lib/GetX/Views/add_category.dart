import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:grinta/GetX/Models/categories_model.dart';
import 'package:grinta/GetX/Services/database_service.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Views/admin_panel_view.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryView extends StatelessWidget {
  AddCategoryView({Key? key}) : super(key: key);

  final TextEditingController cNameController = TextEditingController();

  late File image;
  final imageIsNull = true.obs;
  final uploadingData = false.obs;
  final uploadedImageUrl = "".obs;

  // String uploadedImageUrl = "";

  chooseImage() async {
    final imgPicker = ImagePicker();
    PickedFile? pickedFile =
        await imgPicker.getImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    imageIsNull.value = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kBlackColor,
          title: const Text("Grinta",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(
            () => Column(
              children: [
                const Text(
                  "Add Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kGreyColor,
                  ),
                  padding: const EdgeInsets.only(left: 15, right: 0),
                  child: TextFormField(
                    controller: cNameController,
                    cursorColor: kBlackColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: kBlackColor,
                      hintText: 'New Category Name',
                      hintStyle: TextStyle(fontSize: 13, color: kBlackColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text("Upload image",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Center(
                  child: GestureDetector(
                    child: Container(
                      height: size.height * 0.07,
                      width: size.width * 0.86,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: Text(
                        imageIsNull.value
                            ? "Upload image (click me)"
                            : "Image Uploaded",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      chooseImage();
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const SizedBox(height: 8),
                MaterialButton(
                    color: kBlackColor,
                    padding: const EdgeInsets.all(0),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '+ Add New Category ',
                        style: TextStyle(color: kWhiteColor),
                      ),
                    ),
                    onPressed: () async {
                      if (cNameController.text.isNotEmpty &&
                          !imageIsNull.value) {
                        uploadingData.value = true;

                        final String _pName = cNameController.text;

                        //Store img
                        FirebaseStorage storage = FirebaseStorage.instance;
                        Reference ref = storage
                            .ref()
                            .child("image" + DateTime.now().toString());
                        UploadTask uploadTask = ref.putFile(image);
                        await uploadTask.whenComplete(() async {
                          String url = (await ref.getDownloadURL()).toString();
                          uploadedImageUrl.value = url;

                          debugPrint(url);
                        }).catchError((onError) {
                          debugPrint(onError);
                        });

                        if (uploadedImageUrl.value != "") {
                          final CategoriesModel category = CategoriesModel(
                            name: _pName,
                            img: uploadedImageUrl.value,
                          );
                          debugPrint(uploadedImageUrl.value);
                          await Database()
                              .insertCategory(category.toMap(), _pName);
                        }

                        cNameController.clear();
                        uploadingData.value = false;
                        imageIsNull.value = true;
                        Get.off(() => AdminPanelView());
                        Get.snackbar('Category Uploaded',
                            'Category is Uploaded Successfully',
                            backgroundColor: kBlackColor,
                            colorText: kWhiteColor,
                            snackPosition: SnackPosition.TOP);
                      } else {
                        Get.snackbar('Can\'t Upload',
                            'Please fill Name and Upload Image.',
                            backgroundColor: kBlackColor,
                            colorText: kWhiteColor,
                            snackPosition: SnackPosition.TOP);
                      }
                    }
                    // onPressed: () async {
                    // if (textController.text != '') {
                    //   await Database().addBranch(textController.text);
                    //   textController.clear();
                    // } else {
                    //   Get.snackbar(
                    //       'Branch Name Required', 'Type branch name first.',
                    //       colorText: kWhiteColor);
                    // }
                    // },
                    ),
                uploadingData.value
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: kBlackColor,
                      ))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
