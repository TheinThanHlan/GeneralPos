import 'package:flutter/material.dart';
import 'package:general_pos/data/all.dart';

import '../../mvc_template/abstract/MVCController.dart';

class ManagePropertyNamesController extends MVCController {
  ManagePropertyNamesController();
  String greet = "Hello from ManagePropertyNamesPage";

  var searchController = TextEditingController();
  var propertyValueSearchController = TextEditingController();
  var addEditTmpPropertyName = ProductPropertyName(name: "");
  String showDialogErrorMessage = "";
  ProductPropertyName currentPropertyName = ProductPropertyName(name: "");

  Future<List<ProductPropertyName>> getPropertyNames(
      {String searchName = ""}) async {
    return getIt<ProductPropertyNameDao>()
        .readAllWithSearch(search: searchName);
  }

  Future<bool> addPropertyName(Function setState) async {
    if ((await getIt<ProductPropertyNameDao>()
                .searchWithName(this.searchController.text.trim()))
            .length !=
        0) {
      showDialogErrorMessage = "Property name already existed.";
      setState(() {});
      return false;
    }
    if (searchController.text.isEmpty) {
      showDialogErrorMessage = "Property name cannot empty.";
      setState(() {});
      return false;
    }
    this.addEditTmpPropertyName.name = this.searchController.text;
    getIt<ProductPropertyNameDao>().insertWithoutDbAuto(addEditTmpPropertyName);
    setState(() {});
    return true;
  }

  Future<bool> addPropertyValue(Function setState) async {
    if (propertyValueSearchController.text.isEmpty) {
      showDialogErrorMessage = "Property value cannot empty.";
      setState(() {});
      return false;
    }
    if (currentPropertyName.id == null) {
      showDialogErrorMessage = "Please Choose Property Name.";
      setState(() {});
      return false;
    }
    ProductProperty p = ProductProperty(
        value: propertyValueSearchController.text,
        productPropertyName: currentPropertyName);
    await getIt<ProductPropertyDao>().insert(p);
    setState(() {});
    return true;
  }
}
