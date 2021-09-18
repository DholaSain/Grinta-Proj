import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  String? name;
  String? img;

  CategoriesModel({
    this.name,
    this.img,
  });

  CategoriesModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    name = doc.get('name');
    img = doc.get('img');
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "img": img,
    };
  }
}
