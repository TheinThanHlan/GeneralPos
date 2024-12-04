import '../../mvc_template/abstract/MVCController.dart';
import '../../data/all.dart';
import 'package:flutter/widgets.dart';

class BuyController extends MVCController {
  BuyController();
  String greet = "Hello from BuyPage";
  TextEditingController voucherNameInputController = TextEditingController();
  ValueNotifier<Voucher?> currentVoucher = ValueNotifier(null);
  ValueNotifier<ProductTemplate> currentProductTemplate =
      ValueNotifier(ProductTemplate(id: 0, name: ""));

  Future<bool> addVoucher() async {
    getIt<VoucherDao>()
        .createNewVoucher(
      Voucher(
        name: voucherNameInputController.text,
        status: VoucherStatus(id: 1, name: ""),
        discount: 0,
        totalPrice: 0,
        type: VoucherType(id: 2, name: ""),
      ),
    )
        .then((x) {
      print(x);
    }).catchError((x) {
      print(x.toString());
    });
    return true;
  }

  void resetData() {
    this.voucherNameInputController.clear();
  }
}
