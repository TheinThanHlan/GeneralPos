import './SalesController.dart';
import './SalesPage.dart';
import 'package:get_it/get_it.dart';

void injectSales(GetIt getIt) {
  getIt.registerSingleton(SalesController());
  getIt.registerSingleton(SalesPage(getIt<SalesController>()));
  print("\t~>\tSales injected;");
}
