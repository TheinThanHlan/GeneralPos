import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import '../../data/all.dart';
import './OrderingController.dart';
import 'OrderingModel.dart';
import 'package:data_table_2/data_table_2.dart';

class Tablet extends StatefulWidget {
  late final OrderingController controller;
  Tablet({required this.controller});

//  Widget build(BuildContext context) {
//    return Text(controller.greet);
//  }

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Tablet();
  }
}

class _Tablet extends State<Tablet> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Order တင်ရန်"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: OutlinedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: OutlinedButton(
                child: Text("Ok"),
                onPressed: () {
                  widget.controller.orderConfirmed().then((_) {
                    Navigator.of(context).pop();
                  });
                }),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("filter"),
            getIt<GlobalUtils>().vGap(),
            Row(
              children: [
                FutureBuilder(
                  future: getIt<ProductTemplateDao>()
                      .readWhereInventoryExists()
                      .catchError((e) {
                    print(e);
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      Future.delayed(Duration(milliseconds: 10)).then((_) {
                        var x = widget.controller.inventoryFilter.value;
                        x.productTemplate = snapshot.data!.first;
                        widget.controller.inventoryFilter.value = x.clone();
                      });
                      return DropdownMenu(
                        initialSelection: snapshot.data!.first,
                        onSelected: (a) {
                          var x = widget.controller.inventoryFilter.value;
                          x.productTemplate = a;
                          widget.controller.inventoryFilter.value = x.clone();
                        },
                        dropdownMenuEntries: snapshot.data!.map((p) {
                          return DropdownMenuEntry(label: p.name, value: p);
                        }).toList(),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
            getIt<GlobalUtils>().vGap(),
            Text("Product အားရွေးချယ်ပါ"),
            getIt<GlobalUtils>().vGap(),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: widget.controller.inventoryFilter,
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: getIt<InventoryDao>().readLike(value),
                        builder: (context, snapshot) {
                          widget.controller.quantityToOrder.text = "1";
                          return DropdownMenu(
                              width: double.maxFinite,
                              menuHeight: 400,
                              onSelected: (a) {
                                widget.controller.currentInventory.value = a ??
                                    widget.controller.currentInventory.value;
                              },
                              dropdownMenuEntries: [
                                if (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty)
                                  ...snapshot.data!.map((e) {
                                    return DropdownMenuEntry(
                                        label: widget.controller
                                            .choose_inventory_string_formatter(
                                                e),
                                        value: e);
                                  }).toList()
                              ]);
                        },
                      );
                    },
                  ),
                ),
                getIt<GlobalUtils>().hGap(),
                SizedBox(
                    width: getIt<GlobalConfig>().width,
                    child: TextFormField(
                        controller: widget.controller.quantityToOrder,
                        decoration: InputDecoration(label: Text("Qty")))),
                getIt<GlobalUtils>().hGap(),
                ValueListenableBuilder(
                    valueListenable: widget.controller.currentInventory,
                    builder: (context, value, child) {
                      return Text("Price - ${value.currentPrice.price} Ks");
                    }),
                getIt<GlobalUtils>().hGap(),
                OutlinedButton(
                    child: Text("Add"),
                    onPressed: () {
                      int qty =
                          int.parse(widget.controller.quantityToOrder.text);
                      qty = qty == 0 ? 1 : qty;
                      widget.controller.addOrder(
                          widget.controller.currentInventory.value, qty);
                      widget.controller.quantityToOrder.text = "1";
                    })
              ],
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: widget.controller.isAddedOrdersChanged,
                builder: (context, value, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        //DataColumn(label: Text("စဉ်")),
                        DataColumn(label: Text("ကုန်ပစ္စည်းအမည်")),
                        DataColumn(label: Text("Qty."), numeric: true),
                        DataColumn(label: Text("")),
                      ],
                      rows: [
                        ...widget.controller.addedOrders.entries.map((e) {
                          return DataRow(cells: [
                            DataCell(Text(widget.controller
                                .choose_inventory_string_formatter(
                                    e.value.item))),
                            DataCell(Text(e.value.qty.toString())),
                            //add delete reduce buttons
                            DataCell(
                              ButtonBar(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        widget.controller.addedOrders
                                            .remove(e.key);
                                        //notify the value notifier
                                        widget.controller.isAddedOrdersChanged
                                                .value =
                                            !widget.controller
                                                .isAddedOrdersChanged.value;
                                      }),
                                  TextButton(
                                      child: Text("-1"),
                                      onPressed: () {
                                        widget.controller.addedOrders[e.key]!
                                            .qty -= 1;

                                        //delete the order from map when qty <= 0
                                        if (widget.controller
                                                .addedOrders[e.key]!.qty <=
                                            0) {
                                          widget.controller.addedOrders
                                              .remove(e.key);
                                        }
                                        //notify the value notifier
                                        widget.controller.isAddedOrdersChanged
                                                .value =
                                            !widget.controller
                                                .isAddedOrdersChanged.value;
                                      }),
                                  TextButton(
                                    child: Text("+1"),
                                    onPressed: () {
                                      widget.controller.addedOrders[e.key]
                                          ?.qty += 1;
                                      //notify the value notifier
                                      widget.controller.isAddedOrdersChanged
                                              .value =
                                          !widget.controller
                                              .isAddedOrdersChanged.value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        })
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
