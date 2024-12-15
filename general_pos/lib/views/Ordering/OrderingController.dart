import '../../mvc_template/abstract/MVCController.dart';
import 'OrderingModel.dart';
import 'package:flutter/material.dart';
import "../../data/all.dart";

class OrderingController extends MVCController {
  final OrderingModel? data;
  OrderingController(this.data);
  String greet = "Hello from OrderingPage";
  ValueNotifier<Inventory> inventoryFilter = ValueNotifier<Inventory>(
      Inventory(currentPrice: ProductPrice(price: 0), qty: 0));
  ValueNotifier<Inventory> currentInventory = ValueNotifier<Inventory>(
      Inventory(currentPrice: ProductPrice(price: 0), qty: 0));

  Map<int, Order> addedOrders = Map<int, Order>();
  TextEditingController quantityToOrder = TextEditingController(text: "1");
  ValueNotifier<bool> isAddedOrdersChanged = ValueNotifier(true);

  String choose_inventory_string_formatter(Inventory i) {
    return i.productTemplate!.name +
        " " +
        i.productProperties!.map((e) => e.value).join(" ");
  }

  void addOrder(Inventory i, int qty) {
    if (!addedOrders.containsKey(i.id) && i.id != 0) {
      addedOrders[i.id!] = Order(
        item: i,
        qty: qty,
        orderDateTime: DateTime.now(),
        voucher: data!.currentVoucher,
        orderStatus: OrderStatus(id: 1, name: ""),
      );
    } else {
      addedOrders[i.id]!.qty += qty;
    }
    isAddedOrdersChanged.value = !isAddedOrdersChanged.value;
  }

  Future<void> orderConfirmed() async {
    for (var value in addedOrders.values) {
      await getIt<OrderDao>().insert(value);
    }
  }
}
