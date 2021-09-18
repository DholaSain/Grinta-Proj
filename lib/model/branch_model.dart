class BranchModel {
  final String name;

  BranchModel({required this.name});

  Map<String, dynamic> toMap() {
    return {
      "branch_name": this.name,
    };
  }
}
