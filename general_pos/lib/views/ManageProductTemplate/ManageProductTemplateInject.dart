import './ManageProductTemplateController.dart';
import './ManageProductTemplatePage.dart';
import 'package:get_it/get_it.dart';

void injectManageProductTemplate(GetIt getIt) {
  getIt.registerSingleton(ManageProductTemplateController());
  getIt.registerSingleton(
      ManageProductTemplatePage(getIt<ManageProductTemplateController>()));
  print("\t~>\tManageProductTemplate injected;");
}
