import '../../mvc_template/abstract/MVCController.dart';
import "package:flutter/widgets.dart";
import "../../data/all.dart";

class SalesController extends MVCController {
  SalesController() {
    resetAllData();
  }
  String greet = "Hello from SalesPage";
  var searchController = TextEditingController();
  var addOrderSearchController = TextEditingController();
  var ddSearchController = TextEditingController();
  var isAddOrder = false;
  ValueNotifier<Map<int, Order>> addedOrders = ValueNotifier({});

  StringBuffer addVoucherErrorMessage = StringBuffer("");
  StringBuffer addOrderErrorMessage = StringBuffer("");
  late ServingTable selectedTable;
  ValueNotifier<Voucher> currentVoucher = ValueNotifier(
    Voucher(
      totalPrice: 0,
      discount: 0,
      status: VoucherStatus(name: ""),
      type: VoucherType(name: ""),
    ),
  );
  double totalPrice = 0;

  Future<bool> addVoucher() async {
    String tmp_name = "";
    int openedVouchersOfTable = await getIt<VoucherDao>()
            .readLastOpenVoucherNumberOfTable(selectedTable) +
        1;
    if (openedVouchersOfTable > 0) {
      print(openedVouchersOfTable);
      tmp_name = (openedVouchersOfTable).toString();
    }
    getIt<VoucherDao>()
        .createNewVoucher(
      Voucher(
        name: tmp_name,
        status: VoucherStatus(name: ""),
        discount: 0,
        totalPrice: 0,
        table: selectedTable,
        type: VoucherType(id: 1, name: ""),
      ),
    )
        .then((x) {
      print(x);
    }).catchError((x) {
      print(x.toString());
    });
    return true;
  }

  void resetAllData() {
    addVoucherErrorMessage.clear();
    addOrderErrorMessage.clear();
    searchController.clear();
    ddSearchController.clear();
    addOrderSearchController.clear();
    addedOrders.value = {};
  }

  void addNewOrder(MapEntry<int, Inventory> a) {
    if (!addedOrders.value.containsKey(a.key)) {
      addedOrders.value = {
        ...addedOrders.value,
        a.key: Order(
          item: a.value,
          qty: 1,
          orderDateTime: DateTime.now(),
          voucher: currentVoucher.value,
          orderStatus: OrderStatus(id: 1, name: ""),
        )
      };
    } else {
      addedOrders.value[a.key]!.qty += 1;
      addedOrders.value = {...addedOrders.value};
    }
  }

  void substractOrder(int a) {
    if (addedOrders.value.containsKey(a)) {
      addedOrders.value[a]!.qty -= 1;
      if (addedOrders.value[a]!.qty == 0) {
        addedOrders.value.remove(a);
      }
      addedOrders.value = {...addedOrders.value};
    }
  }

  Future<bool> insertOrders() async {
    for (var a in addedOrders.value.entries) {
      await getIt<OrderDao>().insert(a.value);
    }
    return true;
  }
}
