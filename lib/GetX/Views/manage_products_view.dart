import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Bindings/all_bindings.dart';
import 'package:grinta/GetX/Controllers/categories_view_model.dart';
import 'package:grinta/GetX/Controllers/products_controller.dart';
import 'package:grinta/GetX/Services/database_service.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Utils/global_variables.dart';
import 'package:grinta/GetX/Views/add_product_view.dart';

class ProductsCategoriesView extends StatelessWidget {
  ProductsCategoriesView({Key? key}) : super(key: key);
  final cController = Get.find<CategoriesViewContrller>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: const Text(
          "Grinta",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                'Select Category to Manage Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: cController.allCategories!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        categoryName.value =
                            cController.allCategories![index].name;
                        Get.to(() => ManageProductView(),
                            binding: ProductsBinding());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: size.height * 0.008),
                        decoration: BoxDecoration(
                            color: kGreyColor,
                            border:
                                Border.all(color: Colors.blueGrey, width: 1.0),
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                cController.allCategories![index].img!,
                              ),
                              fit: BoxFit.cover,
                            )),
                        child: Text(
                          cController.allCategories![index].name!,
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class ManageProductView extends StatelessWidget {
  ManageProductView({Key? key}) : super(key: key);

  final pController = Get.find<ProductsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: const Text(
          "Grinta",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'All Categories',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() {
              if (pController.allProducts == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (pController.allProducts!.length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pController.allProducts!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: kGreyColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(pController.allProducts![index].name!),
                            subtitle: Text(
                                pController.allProducts![index].description!),
                            leading: Image.network(
                              pController.allProducts![index].img!,
                              width: 40,
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: kRedColor,
                              ),
                              onPressed: () async {
                                await Database().deleteProduct(
                                    pController.allProducts![index].name!);
                                Get.back();
                                Get.snackbar('Product Deleted',
                                    'Product Deleted Successfully.',
                                    backgroundColor: kBlackColor,
                                    colorText: kWhiteColor,
                                    snackPosition: SnackPosition.TOP);
                              },
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                    child: Text('There are no Products available.'));
              }
            }),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.off(() => AddProductView());
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.black87),
                  child: const Text(
                    "+ Add New Product",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
