import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grinta/model/price_model.dart';

class AddMenuPrice extends StatefulWidget {
  final String uid;
  const AddMenuPrice({Key? key, required this.uid}) : super(key: key);

  @override
  _AddMenuPriceState createState() => _AddMenuPriceState();
}

class _AddMenuPriceState extends State<AddMenuPrice> {
  final firebaseFirestore = FirebaseFirestore.instance;
  bool uploadingData = false;

  Future<void> insertData(final product) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("products")
        .doc(widget.uid)
        .set(product, SetOptions(merge: true))
        .then((_) {
      print("success!");
    }).catchError((e) {
      print(e.toString());
    });
  }

  List<TextEditingController> _priceControllers = [];

  var _stream;

  @override
  void initState() {
    _stream = firebaseFirestore.collection("branches").snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Grinta",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height * 0.8,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.02),
          child: new StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.hasError) {
                  return Text("Some Error Occurs");
                } else if (querySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: Text("Loading..."));
                  // } else if (querySnapshot.connectionState ==
                  //     ConnectionState.waiting) {
                  //   return Center(child: Text("waiting"));
                  // } else if (querySnapshot.connectionState ==
                  //     ConnectionState.done) {
                  //   return Center(child: Text("Done"));
                } else {
                  _priceControllers.add(new TextEditingController());
                  final list = querySnapshot.data!.docs;
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        String price = "";
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              "Price for " + list[index]["branch_name"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * 0.04,
                                  right: size.width * 0.04),
                              child: TextField(
                                  controller: _priceControllers[index],
                                  decoration: InputDecoration(
                                      hintText: "200",
                                      hintStyle:
                                          TextStyle(color: Colors.grey))),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              height: size.height * 0.1,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 50,
                                width: size.width * 0.8,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (price == "") {
                                      setState(() {
                                        uploadingData = true;
                                      });

                                      // final String _pPrice = price;
                                      final String _pBranchName =
                                          list[index]["branch_name"];

                                      final PriceModel _priceModel = PriceModel(
                                        price: _priceControllers[index].text,
                                        branchName: _pBranchName,
                                      );

                                      insertData(_priceModel.toMap());

                                      setState(() {
                                        price = "";
                                        uploadingData = false;
                                      });
                                      var snackBar = SnackBar(
                                          content: Text(
                                              'Product Price is Uploaded Successfully'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Please fill Price field.'),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add),
                                            Text(
                                              "Add Prices",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }
              }),
        ),
      ),
    );
  }
}
