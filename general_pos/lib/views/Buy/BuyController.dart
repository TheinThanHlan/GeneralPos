import '../../mvc_template/abstract/MVCController.dart';
import '../../data/all.dart';
import 'package:flutter/widgets.dart';

class BuyController extends MVCController {
  BuyController();
  String greet = "Hello from BuyPage";
  TextEditingController voucherNameInputController = TextEditingController();
  TextEditingController buyPriceInputController = TextEditingController();

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

  void addOrder(Inventory inventory) {}

  void resetAddOrder() {}
  List<int> orderStatusSteps = [1, 5, 6];
  int getNextStatusStep(Order o) {
    int output = 1;
    for (var a = 0; a < orderStatusSteps.length; a++) {
      if (orderStatusSteps[a] == o.orderStatus.id) {
        if (orderStatusSteps.length - 1 == a) {
          output = 0;
        } else {
          output = orderStatusSteps[a + 1];
        }
        break;
      }
    }
    return output;
  }
}
