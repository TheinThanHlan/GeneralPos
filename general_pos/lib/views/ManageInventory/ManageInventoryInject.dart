import './ManageInventoryController.dart';
import './ManageInventoryPage.dart';
import 'package:get_it/get_it.dart';

void injectManageInventory(GetIt getIt) {
  getIt.registerSingleton(ManageInventoryController());
  getIt.registerSingleton(
      ManageInventoryPage(getIt<ManageInventoryController>()));
  print("\t~>\tManageInventory injected;");
}
