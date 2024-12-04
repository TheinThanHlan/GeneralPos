import './ManageController.dart';
import './ManagePage.dart';
import 'package:get_it/get_it.dart';

void injectManage(GetIt getIt) {
  getIt.registerSingleton(ManageController());
  getIt.registerSingleton(ManagePage(controller: getIt<ManageController>()));
  print("\t~>\tManage injected;");
}
