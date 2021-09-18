import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  String? name;
  // String? id;

  BranchModel({this.name});

  BranchModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    name = doc.get('name');
  }
}
