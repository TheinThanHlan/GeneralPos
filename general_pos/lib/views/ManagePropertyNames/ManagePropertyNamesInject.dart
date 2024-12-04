import './ManagePropertyNamesController.dart';
import './ManagePropertyNamesPage.dart';
import 'package:get_it/get_it.dart';

void injectManagePropertyNames(GetIt getIt) {
  getIt.registerSingleton(ManagePropertyNamesController());
  getIt.registerSingleton(
      ManagePropertyNamesPage(getIt<ManagePropertyNamesController>()));
  print("\t~>\tManagePropertyNames injected;");
}
