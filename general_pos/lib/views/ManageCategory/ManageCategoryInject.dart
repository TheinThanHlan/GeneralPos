import './ManageCategoryController.dart';
import './ManageCategoryPage.dart';
import 'package:get_it/get_it.dart';

void injectManageCategory(GetIt getIt) {
  getIt.registerSingleton(ManageCategoryController());
  getIt.registerSingleton(
      ManageCategoryPage(controller: getIt<ManageCategoryController>()));
  print("\t~>\tManageCategory injected;");
}
