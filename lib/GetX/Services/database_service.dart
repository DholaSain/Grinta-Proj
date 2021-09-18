import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:grinta/GetX/Controllers/categories_view_model.dart';
import 'package:grinta/GetX/Models/branch_model.dart';
import 'package:grinta/GetX/Models/categories_model.dart';
import 'package:grinta/GetX/Models/products_model.dart';
import 'package:grinta/GetX/Utils/colors.dart';
import 'package:grinta/GetX/Utils/global_variables.dart';
import 'package:grinta/GetX/Views/manage_categories_view.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<BranchModel>> allBranches() {
    return _firestore
        .collection('allBranches')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<BranchModel> branchList = [];
      for (var element in querySnapshot.docs) {
        branchList.add(BranchModel.fromDocumentSnapshot(element));
      }
      return branchList;
    });
  }

  Stream<List<CategoriesModel>> allCategories() {
    return _firestore
        .collection('allBranches')
        .doc(menuBranch.value!)
        .collection('allCategories')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<CategoriesModel> categoriesList = [];
      for (var element in querySnapshot.docs) {
        categoriesList.add(CategoriesModel.fromDocumentSnapshot(element));
      }
      return categoriesList;
    });
  }

  Stream<List<ProductsModel>> allProducts() {
    return _firestore
        .collection('allBranches')
        .doc(menuBranch.value!)
        .collection('allCategories')
        .doc(categoryName.value)
        .collection('allProducts')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<ProductsModel> productsList = [];
      for (var element in querySnapshot.docs) {
        productsList.add(ProductsModel.fromDocumentSnapshot(element));
      }
      return productsList;
    });
  }

  Future<void> deleteBranch(String id) async {
    try {
      await _firestore.collection('allBranches').doc(id).delete();
      Get.back();
      Get.snackbar('Branch Deleted', "Branch Deleted Sucessfully.",
          backgroundColor: kBlackColor,
          colorText: kWhiteColor,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: kBlackColor,
          colorText: kRedColor,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addBranch(String name) async {
    try {
      await _firestore.collection('allBranches').doc(name).set({'name': name});
      Get.snackbar('Branch Added', "Branch Added Sucessfully.",
          backgroundColor: kBlackColor,
          colorText: kWhiteColor,
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: kBlackColor,
          colorText: kRedColor,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> deleteCategory(String id) async {
    await _firestore
        .collection('allBranches')
        .doc(menuBranch.value)
        .collection('allCategories')
        .doc(id)
        .delete();
  }

  Future<void> insertCategory(final category, String name) async {
    await _firestore
        .collection("allBranches")
        .doc(menuBranch.value)
        .collection('allCategories')
        .doc(name)
        .set(category);
  }
}
