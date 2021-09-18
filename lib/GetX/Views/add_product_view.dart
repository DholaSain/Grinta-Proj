import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:grinta/GetX/Models/products_model.dart';
import 'package:grinta/GetX/Services/database_service.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Utils/global_variables.dart';
import 'package:image_picker/image_picker.dart';

class AddProductView extends StatelessWidget {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  late File image;
  final imageIsNull = true.obs;
  final uploadingData = false.obs;
  final uploadedImageUrl = "".obs;

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
        title: const Text(
          "Grinta",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.04),
                  child: const Text(
                    "Add Menu Item",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  "Upload image",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                const Text(
                  "Name of item",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.04, right: size.width * 0.04),
                  child: TextField(
                    controller: name,
                    decoration: const InputDecoration(
                        hintText: "Name of Item",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  "Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.04, right: size.width * 0.04),
                  child: TextField(
                    controller: price,
                    decoration: const InputDecoration(
                        hintText: "Price of Item",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.04, right: size.width * 0.04),
                  child: TextField(
                    controller: description,
                    decoration: const InputDecoration(
                        hintText: "Write about product...",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Container(
                  height: size.height * 0.1,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (name.text.isNotEmpty && !imageIsNull.value) {
                          uploadingData.value = true;

                          final String _pName = name.text;
                          final String _pPrice = price.text;
                          final String _pDescription = description.text;
                          //Store img
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference ref = storage
                              .ref()
                              .child("image" + DateTime.now().toString());
                          UploadTask uploadTask = ref.putFile(image);
                          await uploadTask.whenComplete(() async {
                            String url =
                                (await ref.getDownloadURL()).toString();
                            uploadedImageUrl.value = url;

                            debugPrint(url);
                          }).catchError((onError) {
                            debugPrint(onError);
                          });

                          if (uploadedImageUrl.value != "") {
                            final ProductsModel product = ProductsModel(
                              name: _pName,
                              price: _pPrice,
                              img: uploadedImageUrl.value,
                              category: categoryName.value,
                              description: _pDescription,
                            );
                            debugPrint(uploadedImageUrl.value);

                            Database().addProduct(product.toMap(), _pName);

                            // insertData(product.toMap());
                          }

                          name.clear();
                          price.clear();
                          description.clear();

                          uploadingData.value = false;
                          imageIsNull.value = true;

                          Get.back();
                        } else {
                          Get.snackbar(
                              'Fill the Data', 'Please provide the Data',
                              backgroundColor: kBlackColor,
                              colorText: kWhiteColor,
                              snackPosition: SnackPosition.TOP);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                      ),
                      child: uploadingData.value
                          ? const CircularProgressIndicator(
                              color: kWhiteColor,
                            )
                          : const Text(
                              'Add Product',
                              style: TextStyle(color: kWhiteColor),
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
}
