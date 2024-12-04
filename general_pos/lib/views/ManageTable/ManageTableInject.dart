import './ManageTableController.dart';
import './ManageTablePage.dart';
import 'package:get_it/get_it.dart';

void injectManageTable(GetIt getIt) {
  getIt.registerSingleton(ManageTableController());
  getIt.registerSingleton(ManageTablePage(getIt<ManageTableController>()));
  print("\t~>\tManageTable injected;");
}
