import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grinta/model/branch_model.dart';

class ManageBranches extends StatefulWidget {
  const ManageBranches({Key? key}) : super(key: key);

  @override
  _ManageBranchesState createState() => _ManageBranchesState();
}

class _ManageBranchesState extends State<ManageBranches> {
  TextEditingController bname = TextEditingController();
  bool uploadingData = false;

  Future<void> insertData(final product) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("branches")
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
                    "Add Branches",
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
                        "Name of Branches",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        child: TextField(
                          controller: bname,
                          decoration: InputDecoration(
                              hintText: "Hills Roads",
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
                        if (bname.text.isNotEmpty) {
                          setState(() {
                            uploadingData = true;
                          });
                          final String _pName = bname.text;

                          final BranchModel branch = BranchModel(
                            name: _pName,
                          );

                          insertData(branch.toMap());

                          bname.clear();
                          setState(() {
                            uploadingData = false;
                          });
                          var snackBar = SnackBar(
                              content: Text('Branch is Uploaded Successfully'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill Branch Name.'),
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
