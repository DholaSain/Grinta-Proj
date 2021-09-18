class CategoryModel {
  final String name;
  final String img;

  CategoryModel({required this.name, required this.img});

  Map<String, dynamic> toMap() {
    return {
      "category_name": this.name,
      "category_img": this.img,
    };
  }
}
