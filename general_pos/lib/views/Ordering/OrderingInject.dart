import './OrderingController.dart';
import './OrderingPage.dart';
import './OrderingModel.dart';
import 'package:get_it/get_it.dart';

void injectOrdering(GetIt getIt) {
  //getIt.registerSingleton(OrderingController(null));
  //getIt.registerSingleton(OrderingPage(getIt<OrderingController>()));

  getIt.registerFactoryParam<OrderingController, OrderingModel, void>(
      (p1, p2) => OrderingController(p1));
  getIt.registerFactoryParam<OrderingPage, OrderingModel?, void>(
      (p1, p2) => OrderingPage(getIt<OrderingController>(param1: p1)));
  print("\t~>\tOrdering injected;");
}
