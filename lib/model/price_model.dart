class PriceModel {
  final String price;
  final String branchName;
  PriceModel({
    required this.price,
    required this.branchName,
  });

  Map<String, dynamic> toMap() {
    return {
      this.branchName: this.price,
    };
  }
}
