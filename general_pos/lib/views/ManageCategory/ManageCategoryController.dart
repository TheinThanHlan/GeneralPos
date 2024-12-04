import 'package:flutter/material.dart';
import 'package:general_pos/data/dao/ProductCategoryDao.dart';
import 'package:general_pos/data/generated/model/ProductCategory.dart';
import 'package:general_pos/mvc_template/injection_container.dart';
import 'package:general_pos/views/Components/OCDialog/OCDialogModel.dart';

import '../../mvc_template/abstract/MVCController.dart';

class ManageCategoryController extends MVCController {
  String greet = "Hello from ManageCategoryPage";
  //declare variables
  ValueNotifier ERROR_MESSAGE = ValueNotifier("");
  var searchController = TextEditingController();
  var addEditTmpCategory = ProductCategory(name: "");
  StringBuffer addErrorMessage = StringBuffer("");
  Future<List<ProductCategory>> getCategories({String searchName = ""}) async {
    return getIt<ProductCategoryDao>().readAllWithSearch(search: searchName);
  }

  Future<bool> addCategory() async {
    addErrorMessage.clear();
    if ((await getIt<ProductCategoryDao>()
                .searchWith_name(this.searchController.text.trim()))
            .length !=
        0) {
      ERROR_MESSAGE.value = "Product type already existed";
      return false;
    }
    if (searchController.text.isEmpty) {
      ERROR_MESSAGE.value = "Fill the product type in add box first";
      return false;
    }
    this.addEditTmpCategory.name = this.searchController.text;
    getIt<ProductCategoryDao>().insertWithParentCategory(addEditTmpCategory);
    addErrorMessage.clear();
    return true;
  }

  void addCategoryCancel() {
    this.addErrorMessage.clear();
    addEditTmpCategory = ProductCategory(name: "");
  }
}
