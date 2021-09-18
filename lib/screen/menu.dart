import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:grinta/screen/view_produect.dart';

import 'admin_login.dart';

class MenuScreen extends StatefulWidget {
  final String branchName;
  const MenuScreen({Key? key, required this.branchName}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grinta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminLoginScreen(
                            branchName: widget.branchName,
                          )));
            },
            icon: Icon(FontAwesome5.user_shield, size: 20),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: size.height * 0.1,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isGridView = true;
                                  });
                                },
                                icon: Icon(
                                  MfgLabs.th_thumb,
                                  size: 22,
                                )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isGridView = false;
                                  });
                                },
                                icon: Icon(
                                  FontAwesome5.th_list,
                                  size: 22,
                                )),
                          ],
                        )
                      ],
                    )),
                Container(
                  height: size.height * 0.78,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
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

                          return list.isEmpty
                              ? Center(
                                  child: Text(
                                    "No Categories Available",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                )
                              : isGridView
                                  ? GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 300,
                                              childAspectRatio: 4 / 3.5,
                                              crossAxisSpacing: 6,
                                              mainAxisSpacing: 6),
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewProduct(
                                                  branchName: widget.branchName,
                                                  categoryName: list[index]
                                                          ["category_name"]
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: size.height * 0.20,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              border: Border.all(
                                                color: Colors.blueGrey,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: list[index]
                                                      ["category_img"],
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                                Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                    ),
                                                    padding: EdgeInsets.only(
                                                      bottom:
                                                          size.height * 0.01,
                                                      left: size.width * 0.01,
                                                      right: size.width * 0.01,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        list[index]
                                                            ["category_name"],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : ListView.builder(
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewProduct(
                                                          branchName:
                                                              widget.branchName,
                                                          categoryName: list[
                                                                  index]
                                                              ["category_name"],
                                                        )));
                                          },
                                          child: Container(
                                            height: size.height * 0.3,
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.height * 0.008),
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              border: Border.all(
                                                color: Colors.blueGrey,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: list[index]
                                                      ["category_img"],
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                                Center(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                    ),
                                                    padding: EdgeInsets.only(
                                                      bottom:
                                                          size.height * 0.01,
                                                      left: size.width * 0.01,
                                                      right: size.width * 0.01,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        list[index]
                                                            ["category_name"],
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
