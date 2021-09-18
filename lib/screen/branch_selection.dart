import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class BranchSelection extends StatefulWidget {
  const BranchSelection({Key? key}) : super(key: key);

  @override
  _BranchSelectionState createState() => _BranchSelectionState();
}

class _BranchSelectionState extends State<BranchSelection> {
  String branchName = "None";
  String label = "Select Branch...";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: SafeArea(
          child: Center(
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
                    final List<String> bList = [];
                    for (int i = 0; i < list.length; i++) {
                      bList.add(list[i]["branch_name"]);
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: size.width * 0.5,
                        ),
                        Container(
                          width: size.width * 0.6,
                          height: size.width * 0.12,
                          decoration: BoxDecoration(
                            color: Color(0xffECECEC),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            items: bList,
                            label: label,
                            hint: "Select Your Branch",
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            onChanged: (value) {
                              setState(() {
                                label = value!;
                                branchName = value == null ? "None" : value;
                              });
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
                              if (branchName != "None") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              branchName: branchName,
                                            )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select a Branch'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black87),
                            child: Text(
                              "Select",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ));
  }
}
