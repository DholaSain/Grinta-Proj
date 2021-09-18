import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProduct extends StatefulWidget {
  final String categoryName;
  final String branchName;
  const ViewProduct(
      {Key? key, required this.branchName, required this.categoryName})
      : super(key: key);

  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  bool imgLoading = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grinta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height * 0.9,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where("category", isEqualTo: widget.categoryName)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (querySnapshot.hasError) {
                return Text("Some Error Occurs");
              }
              if (querySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final list = querySnapshot.data!.docs;
                final listImage = [];
                for (int i = 0; i < list.length; i++) {
                  listImage.add(list[i]["img"]);
                }
                // bool branchPriceExist =
                //     querySnapshot.data!.docs.contains(widget.branchName);

                imgLoading = false;
                return listImage.isEmpty
                    ? Center(
                        child: Text(
                          "No Products Available",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      )
                    : imgLoading
                        ? Center(child: CircularProgressIndicator())
                        : CarouselSlider(
                            options: CarouselOptions(
                              height: size.height * 0.8,
                              viewportFraction: 0.7,
                              enableInfiniteScroll: false,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            items: list
                                .map(
                                  (item) => Stack(
                                    children: [
                                      Center(
                                        child: Image.network(
                                          item["img"],
                                          fit: BoxFit.cover,
                                          height: size.height * 0.6,
                                        ),
                                      ),
                                      Positioned(
                                          bottom: size.height * 0.00,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["name"],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 26,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "\tPrice: " +
                                                    item[widget.branchName],
                                                // branchPriceExist
                                                //     ? "\tPrice: " +
                                                //         item[widget.branchName]
                                                //     : "\tDefault Price: " +
                                                //         item["price"],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "\n\tDescription: " +
                                                    item["description"],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                                .toList(),
                          );
              }
            }),
      ),
    );
  }
}
