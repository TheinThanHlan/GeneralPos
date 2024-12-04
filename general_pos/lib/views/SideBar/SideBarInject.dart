import './SideBarController.dart';
import './SideBarPage.dart';
import 'package:get_it/get_it.dart';

void injectSideBar(GetIt getIt) {
  getIt.registerSingleton(SideBarController());
  getIt.registerSingleton(SideBarPage(getIt<SideBarController>()));
  print("\t~>\tSideBar injected;");
}
