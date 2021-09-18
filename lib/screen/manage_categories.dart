import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grinta/model/category_models.dart';
import 'package:image_picker/image_picker.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({Key? key}) : super(key: key);

  @override
  _ManageCategoriesState createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  TextEditingController cname = TextEditingController();

  late File image;
  bool imageIsNull = true;
  bool uploadingData = false;
  String uploadedImageUrl = "";

  chooseImage() async {
    final imgPicker = ImagePicker();
    PickedFile? pickedFile =
        await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile!.path);
      imageIsNull = false;
    });
  }

  Future<void> insertData(final product) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("categories")
        .add(product)
        .then((DocumentReference document) {
      print(document.id);
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grinta",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.04),
                  child: Text(
                    "Add Categories",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: size.height * 0.66,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        "Upload image",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Center(
                        child: GestureDetector(
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width * 0.86,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(color: Colors.grey),
                            child: Text(
                              imageIsNull
                                  ? "Upload image (click me)"
                                  : "Image Uploaded",
                              style: TextStyle(
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
                      Text(
                        "Name of Category",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        child: TextField(
                          controller: cname,
                          decoration: InputDecoration(
                              hintText: "Cold Drinks",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      uploadingData
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(),
                    ],
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
                        if (cname.text.isNotEmpty && !imageIsNull) {
                          setState(() {
                            uploadingData = true;
                          });
                          final String _pName = cname.text;

                          //Store img
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference ref = storage
                              .ref()
                              .child("image" + DateTime.now().toString());
                          UploadTask uploadTask = ref.putFile(image);
                          await uploadTask.whenComplete(() async {
                            String url =
                                (await ref.getDownloadURL()).toString();
                            setState(() {
                              uploadedImageUrl = url;
                            });
                            print(url);
                          }).catchError((onError) {
                            print(onError);
                          });

                          if (uploadedImageUrl != "") {
                            final CategoryModel category = CategoryModel(
                              name: _pName,
                              img: uploadedImageUrl,
                            );
                            print(uploadedImageUrl);

                            insertData(category.toMap());
                          }

                          cname.clear();
                          setState(() {
                            uploadingData = false;
                            imageIsNull = true;
                          });
                          var snackBar = SnackBar(
                              content:
                                  Text('Category is Uploaded Successfully'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Please fill Name and Upload Image.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text(
                            "Add Category",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
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
