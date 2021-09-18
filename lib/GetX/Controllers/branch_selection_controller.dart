import 'package:get/get.dart';
import 'package:grinta/GetX/Models/branch_model.dart';
import 'package:grinta/GetX/Services/database_service.dart';

class BranchSelectionController extends GetxController {
  Rxn<List<BranchModel>> branches = Rxn<List<BranchModel>>();

  Rxn<String> branchName = Rxn<String>('None');
  Rxn<String> label = Rxn<String>("Select Branch...");

  List<BranchModel>? get allBranchesNames => branches.value;

  @override
  void onInit() {
    super.onInit();
    branches.bindStream(Database().allBranches());
  }
}
