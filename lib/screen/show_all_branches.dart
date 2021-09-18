import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:grinta/screen/manage_branches.dart';
import 'package:grinta/screen/manage_categories.dart';

class ShowAllBranches extends StatefulWidget {
  const ShowAllBranches({Key? key}) : super(key: key);

  @override
  _ShowAllBranchesState createState() => _ShowAllBranchesState();
}

class _ShowAllBranchesState extends State<ShowAllBranches> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: size.height * 0.1,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Branches Items",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Container(
                  height: size.height * 0.64,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("branches")
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
                                    "No Branch Available",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Container(
                                        height: size.height * 0.16,
                                        margin:
                                            EdgeInsets.all(size.height * 0.007),
                                        alignment: Alignment.bottomLeft,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            border: Border.all(
                                              color: Colors.blueGrey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: size.height * 0.16,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          padding: EdgeInsets.only(
                                            left: size.width * 0.04,
                                            right: size.width * 0.04,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Text(
                                                      list[index]
                                                          ["branch_name"],
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                behavior: HitTestBehavior
                                                    .deferToChild,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.height * 0.01),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.01),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(50),
                                                            topLeft:
                                                                Radius.circular(
                                                                    50)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesome5.trash,
                                                        color: Colors.red,
                                                        size:
                                                            size.height * 0.04,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  querySnapshot.data!.docs
                                                      .forEach((doc) {
                                                    if (list[index]
                                                            ["branch_name"] ==
                                                        doc["branch_name"]) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'branches')
                                                          .doc(doc.id)
                                                          .delete()
                                                          .then((value) => print(
                                                              "User Deleted"))
                                                          .catchError((error) =>
                                                              print(
                                                                  "Failed to delete user: $error"));
                                                      print(doc["branch_name"]);
                                                    }
                                                  });
                                                  var snackBar = const SnackBar(
                                                      content: Text(
                                                          'Branch Deleted Successfully'));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                        }
                      }),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  height: size.height * 0.08,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManageBranches()));
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black87),
                      child: const Text(
                        "Add Branches",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
