import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Controllers/products_controller.dart';

class ProductsView extends StatelessWidget {
  ProductsView({
    Key? key,
  }) : super(key: key);
  // final String category;
  final controllerP = Get.find<ProductsController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controllerP.allProducts == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (controllerP.allProducts!.length > 0) {
            // return Text(controller.allCategories!.first.name!);
            final list = controllerP.allProducts;
            final listImage = [];
            for (int i = 0; i < list!.length; i++) {
              listImage.add(list[i].img);
            }
            return CarouselSlider(
              options: CarouselOptions(
                height: size.height * 0.8,
                viewportFraction: 0.7,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: list
                  .map(
                    (item) => Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.img!,
                              fit: BoxFit.cover,
                              height: size.height * 0.6,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: size.height * 0.00,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "\tPrice: " + item.price!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "\n\tDescription: " + item.description!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(
                child: Text(
              'No Products Available.',
              style: TextStyle(
                fontSize: 22,
              ),
            ));
          }
        }),
      ),
    );
  }
}
