import './BuyController.dart';
import './BuyPage.dart';
import 'package:get_it/get_it.dart';

void injectBuy(GetIt getIt) {
  getIt.registerSingleton(BuyController());
  getIt.registerSingleton(BuyPage(getIt<BuyController>()));
  print("\t~>\tBuy injected;");
}
