import '../../mvc_template/abstract/MVCController.dart';
import 'package:flutter/widgets.dart';
import '../../data/all.dart';

class VoucherHistoryController extends MVCController {
  VoucherHistoryController() {
    resetAllData();
  }
  bool isShowDetail = false;
  late final ValueNotifier<Voucher> listenableVoucher;
  String greet = "Hello from VoucherHistoryPage";
  void resetAllData() {
    listenableVoucher = ValueNotifier(
      Voucher(
        totalPrice: 0,
        discount: 0,
        status: VoucherStatus(name: ""),
        type: VoucherType(name: ""),
      ),
    );
  }
}
