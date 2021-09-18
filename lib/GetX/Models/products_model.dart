import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  String? name;
  String? price;
  String? img;
  String? category;
  String? description;

  ProductsModel({
    this.category,
    this.name,
    this.price,
    this.img,
    this.description,
  });

  ProductsModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    name = doc.get('name');
    price = doc.get('price');
    img = doc.get('img');
    category = doc.get('category');
    description = doc.get('description');
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "img": img,
      "category": category,
      "description": description
    };
  }
}
