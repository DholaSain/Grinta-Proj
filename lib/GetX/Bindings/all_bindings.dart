import 'package:get/get.dart';
import 'package:grinta/GetX/Controllers/categories_view_model.dart';
import 'package:grinta/GetX/Controllers/products_controller.dart';

class CategoriesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesViewContrller>(() => CategoriesViewContrller());
  }
}

class ProductsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsController>(() => ProductsController());
  }
}
