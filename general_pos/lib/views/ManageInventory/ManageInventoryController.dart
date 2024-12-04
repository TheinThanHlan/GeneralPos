import '../../mvc_template/abstract/MVCController.dart';
import "package:flutter/widgets.dart";
import "../../data/all.dart";

class ManageInventoryController extends MVCController {
  String greet = "Hello from ManageInventoryPage";
  //declare variables
  var searchController = TextEditingController();
  var addPropertyValueController = TextEditingController();
  var selectedProductPropertyController = TextEditingController();
  ValueNotifier<int> currentProductTemplateIdNoti = ValueNotifier(0);
  ProductTemplate currentProductTemplate = ProductTemplate(name: "", id: 0);

  var addEditTmpInventory = Inventory(
      productTemplate: null,
      currentPrice: ProductPrice(price: 0),
      productProperties: [],
      qty: 0);

  late ProductTemplate addEditTmpProductTemplate;
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

  ManageInventoryController() {
    resetData();
  }
  StringBuffer addErrorMessage = StringBuffer("");
  Function? addProductTemplateOCDialogSetState;
  void setAddProductTemplateOCDialogSetState(Function setState) {
    this.addOCDialogSetState = setState;
  }

  Future<bool> addInventory() async {
    if (addEditTmpInventory.productTemplate!.id == null) {
      this.addErrorMessage.clear();
      addErrorMessage.write("Choose Product");
      return false;
    }
    if (addEditTmpInventory.currentPrice.price == 0) {
      this.addErrorMessage.clear();
      addErrorMessage.write("Fill Product Price");
      return false;
    }
    await getIt<InventoryDao>().insert(addEditTmpInventory);
    return true;
  }

  void resetData() {
    this.addErrorMessage.clear();
    addEditTmpInventory = Inventory(
        productTemplate: addEditTmpInventory.productTemplate,
        currentPrice: ProductPrice(price: 0),
        productProperties: [],
        qty: 0);
    showDialogErrorMessage.clear();
    addEditTmpProductTemplate = ProductTemplate(name: "", categories: []);
    addPropertyValueController.clear();
  }
}
