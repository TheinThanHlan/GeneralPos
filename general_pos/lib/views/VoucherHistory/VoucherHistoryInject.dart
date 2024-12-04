import './VoucherHistoryController.dart';
import './VoucherHistoryPage.dart';
import 'package:get_it/get_it.dart';

void injectVoucherHistory(GetIt getIt) {
  getIt.registerSingleton(VoucherHistoryController());
  getIt
      .registerSingleton(VoucherHistoryPage(getIt<VoucherHistoryController>()));
  print("\t~>\tVoucherHistory injected;");
}
