import 'package:get/get.dart';
import 'package:grinta/GetX/Models/categories_model.dart';
import 'package:grinta/GetX/Services/database_service.dart';

class CategoriesViewContrller extends GetxController {
  Rxn<List<CategoriesModel>> categories = Rxn<List<CategoriesModel>>();

  List<CategoriesModel>? get allCategories => categories.value;

  @override
  void onInit() {
    categories.bindStream(Database().allCategories());
    super.onInit();
  }
}
