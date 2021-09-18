import 'package:get/get.dart';
import 'package:grinta/GetX/Models/products_model.dart';
import 'package:grinta/GetX/Services/database_service.dart';

class ProductsController extends GetxController {
  Rxn<List<ProductsModel>> products = Rxn<List<ProductsModel>>();

  List<ProductsModel>? get allProducts => products.value;

  @override
  void onInit() {
    products.bindStream(Database().allProducts());
    super.onInit();
  }
}
