import 'package:flutter/material.dart';
import 'package:general_pos/data/all.dart';

import '../../mvc_template/abstract/MVCController.dart';

class ManageProductTemplateController extends MVCController {
  ManageProductTemplateController() {
    resetAllFields();
  }
  String greet = "Hello from ManageProductTemplatePage";

  late ProductTemplate addEditTmpProductTemplate;
  var searchController = TextEditingController();
  var chooseCategoryController = TextEditingController();
  StringBuffer showDialogErrorMessage = StringBuffer();
  Function? addOCDialogSetState;

  void setAddOCDialogSetState(Function setState) {
    this.addOCDialogSetState = setState;
  }

  Future<Map<int, ProductTemplate>> getProductTemplate(
      {String searchName = ""}) async {
    return getIt<ProductTemplateDao>().readAllWithSearch(search: searchName);
  }

  Future<bool> addProductTemplate() async {
    if (this.addEditTmpProductTemplate.categories == null) {
      showDialogErrorMessage.clear();
      showDialogErrorMessage.write("အမျိုးစားရွေးချယ်ပါ");
      return false;
    }
    this.addEditTmpProductTemplate.name = this.searchController.text;
    getIt<ProductTemplateDao>().insertWithCategory(addEditTmpProductTemplate);
    return true;
  }

  void resetAllFields() {
    showDialogErrorMessage.clear();
    addEditTmpProductTemplate = ProductTemplate(name: "", categories: []);
  }
}
