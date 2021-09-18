class ProductModel {
  final String name;
  final String price;
  final String img;
  final String category;
  final String description;

  ProductModel({
    required this.category,
    required this.name,
    required this.price,
    required this.img,
    required this.description,
  });

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
