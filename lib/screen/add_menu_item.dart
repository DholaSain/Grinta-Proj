import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grinta/model/product_models.dart';
import 'package:image_picker/image_picker.dart';

import 'add_menu_price.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({Key? key}) : super(key: key);

  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  late File image;
  bool imageIsNull = true;
  bool uploadingData = false;
  String uploadedImageUrl = "";
  String categoriesName = "None";
  String label = "Select Category...";
  String productId = "";

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
        .collection("products")
        .add(product)
        .then((DocumentReference document) {
      setState(() {
        productId = document.id;
      });
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.04),
                  child: Text(
                    "Add Menu Item",
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
                        "Name of item",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        child: TextField(
                          controller: name,
                          decoration: InputDecoration(
                              hintText: "Cappuccino Coffee",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        child: TextField(
                          controller: description,
                          decoration: InputDecoration(
                              hintText: "Write about product...",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("categories")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> querySnapshot) {
                            if (querySnapshot.hasError) {
                              return Text("Some Error Occurs");
                            }
                            if (querySnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              final list = querySnapshot.data!.docs;
                              final List<String> cList = [];
                              for (int i = 0; i < list.length; i++) {
                                cList.add(list[i]["category_name"]);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Categories for Product",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.04),
                                    child: DropdownSearch<String>(
                                      maxHeight: size.height * 0.23,
                                      mode: Mode.MENU,
                                      items: cList,
                                      label: label,
                                      hint: "Select Your Categories",
                                      // popupItemDisabled: (String s) => s.startsWith('I'),
                                      onChanged: (value) {
                                        setState(() {
                                          label = value!;
                                          categoriesName =
                                              value == null ? "None" : value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
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
                        if (categoriesName != "None") {
                          if (name.text.isNotEmpty && !imageIsNull) {
                            setState(() {
                              uploadingData = true;
                            });
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
                              setState(() {
                                uploadedImageUrl = url;
                              });
                              print(url);
                            }).catchError((onError) {
                              print(onError);
                            });

                            if (uploadedImageUrl != "") {
                              final ProductModel product = ProductModel(
                                name: _pName,
                                price: _pPrice,
                                img: uploadedImageUrl,
                                category: categoriesName,
                                description: _pDescription,
                              );
                              print(uploadedImageUrl);

                              insertData(product.toMap());
                            }

                            name.clear();
                            price.clear();
                            description.clear();
                            setState(() {
                              uploadingData = false;
                              imageIsNull = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMenuPrice(
                                          uid: productId,
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please fill both Name, Price and Upload Image.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a Categories'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                      ),
                      child: uploadingData
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.arrow_forward_ios),
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
