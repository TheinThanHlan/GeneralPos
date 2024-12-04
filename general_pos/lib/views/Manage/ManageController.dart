import 'package:flutter/material.dart';
import 'package:general_pos/mvc_template/injection_container.dart';
import 'package:general_pos/views/ManageCategory/ManageCategoryPage.dart';
import 'package:general_pos/views/ManageProductTemplate/ManageProductTemplatePage.dart';
import 'package:general_pos/views/ManagePropertyNames/ManagePropertyNamesPage.dart';
import 'package:general_pos/views/ManageInventory/ManageInventoryPage.dart';
import 'package:general_pos/views/ManageTable/ManageTablePage.dart';
import '../../mvc_template/abstract/MVCController.dart';
import './ManagePage.dart';

class ManageController extends MVCController<ManagePage> {
  ManageController() {
    currentPage = pages[3];
  }
  String greet = "Hello from ManagePage";
  var scrollController = ScrollController();
  late Map<String, dynamic> currentPage;
  List pages = [
    {"name": "Type", "page": getIt<ManageCategoryPage>()},
    {"name": "Property", "page": getIt<ManagePropertyNamesPage>()},
    //{"name": "Product", "page": getIt<ManageProductTemplatePage>()},
    {"name": "Inventory", "page": getIt<ManageInventoryPage>()},
    {"name": "Table", "page": getIt<ManageTablePage>()},
  ];

  List<Widget> getPageList(Function setState) {
    return [
      for (var a = 0; a < pages.length; a++)
        Container(
          alignment: Alignment.topLeft,
          width: 144,
          child: ListTile(
            minTileHeight: 7,
            selected: currentPage == pages[a],
            title: Text(
              pages[a]['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            onTap: () {
              currentPage = pages[a];
              setState(() {});
            },
          ),
        ),
    ];
  }

  List<Widget> getTabList(Function setState) {
    return [
      for (var a = 0; a < pages.length; a++)
        Tab(
          child: Tab(
            text: pages[a]["name"],
          ),
        ),
    ];
  }
}
