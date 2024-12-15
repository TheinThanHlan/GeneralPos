import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './SalesController.dart';
import '../../data/all.dart';
import '../Components/OCDialog/OCDialogModel.dart';
import '../Components/OCDialog/OCDialogComponent.dart';
import '../Components/PrintVoucher/PrintVoucherModel.dart';
import '../Components/PrintVoucher/PrintVoucherComponent.dart';
import '../Ordering/all.dart';

class Tablet extends StatefulWidget {
  late final SalesController controller;
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
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              border:
                  Border(right: getIt<GlobalConfig>().sepreate_border_side)),
          width: getIt<GlobalConfig>().width,
          padding: EdgeInsets.symmetric(horizontal: 2),
          //tables list
          child: Column(
            children: [
              Container(
                height: 55,
                child: TextFormField(
                  controller: widget.controller.searchController,
                  //get the keyboard events
                  onChanged: (x) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    label: Text("Search"),
                    //textinput clear text

                    suffixIcon: InkWell(
                      child: Icon(Icons.clear),
                      onTap: () {
                        widget.controller.searchController.clear();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              Container(
                child: OutlinedButton(
                  child: Text("Add Voucher", style: TextStyle(fontSize: 13)),
                  onPressed: () {
                    addVoucherOcDialog().then((a) {
                      setState(() {});
                    });
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: widget.controller.searchController.text.isNotEmpty
                      ? Text(
                          "result",
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        )
                      : Container(),
                ),
              ),
              Expanded(
                flex: 100 - 5,
                child: FutureBuilder(
                  future: getIt<VoucherDao>().search(Voucher(
                    table: ServingTable(
                        name: widget.controller.searchController.text),
                    totalPrice: 0,
                    discount: 0,
                    status: VoucherStatus(name: ""),
                    type: VoucherType(id: 1, name: ""),
                  )),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return StatefulBuilder(
                        builder: (context, voucherListViewSetState) {
                          return ListView(
                            children: [
                              for (var a = 0; a < snapshot.data!.length; a++)
                                ListTile(
                                  selected: widget
                                          .controller.currentVoucher.value.id ==
                                      snapshot.data![a].id,
                                  title: Text(snapshot.data![a].table!.name),
                                  trailing: Text(snapshot.data![a].name ?? '1'),
                                  onTap: () {
                                    widget.controller.currentVoucher.value =
                                        snapshot.data![a];
                                    widget.controller.resetAllData();
                                    voucherListViewSetState(() {});
                                  },
                                )
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: widget.controller.currentVoucher,
            builder: (context, value, child) {
              if (value.id != null) {
                return Column(
                  children: [
                    //top bar of the order
                    Container(
                      height: getIt<GlobalConfig>().top_bar,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                                "Table : ${value.table!.name} ${value.name!}",
                                style: getIt<GlobalConfig>().titleTextStyle),
                          ),
                          ButtonBar(children: [
                            OutlinedButton(
                              child: Text("Close Voucher",
                                  style: getIt<GlobalConfig>().textStyle),
                              onPressed: () {
                                //double check the closing voucher with show dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          "ဘောင်ချာအား ပိတ်မည် \n ဘောက်ချာအား ပိတ်မည် \n Close voucher"),
                                      actions: [
                                        OutlinedButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        OutlinedButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            getIt<VoucherDao>()
                                                .closeVoucher(widget.controller
                                                    .currentVoucher.value)
                                                .then(
                                              (a) {
                                                widget.controller.currentVoucher
                                                    .value = Voucher(
                                                  totalPrice: 0,
                                                  discount: 0,
                                                  status:
                                                      VoucherStatus(name: ""),
                                                  type: VoucherType(
                                                      id: 0, name: ""),
                                                );
                                                widget.controller
                                                    .resetAllData();
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            OutlinedButton(
                                child: Text("Print",
                                    style: getIt<GlobalConfig>().textStyle),
                                onPressed: () async {
                                  widget.controller.currentVoucher.value
                                      .ListOfOrder_mappedBy_voucher = (await getIt<
                                              OrderDao>()
                                          .readOrdersWith_voucher_searchWith_productTemplateName(
                                              value, ""))
                                      .values
                                      .toList();
                                  var printVoucherModel = PrintVoucherModel(
                                      voucher: widget
                                          .controller.currentVoucher.value,
                                      totalPrice: await getIt<VoucherDao>()
                                          .getTotalPrice(value));
                                  if (printVoucherModel
                                      .voucher
                                      .ListOfOrder_mappedBy_voucher!
                                      .isNotEmpty) {
                                    getIt<PrintVoucherComponent>(
                                            param1: printVoucherModel)
                                        .printVoucher();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text("သတိ"),
                                            content: Text(
                                                "Voucher အလွတ်အား print ထုတ်လို့မရပါ"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ]);
                                      },
                                    );
                                  }
                                }),
                            OutlinedButton(
                              child: Text(
                                "Order",
                                style: getIt<GlobalConfig>().textStyle,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            getIt<OrderingPage>(
                                                param1: OrderingModel(
                                                    currentVoucher: value))))
                                    .then((_) {
                                  setState(() {});
                                });
                              },
                            ),
                          ]),
                        ],
                      ),
                    ),

                    //order list
                    Expanded(
                      child: FutureBuilder(
                        future: getIt<OrderDao>()
                            .readOrdersWith_voucher_searchWith_productTemplateName(
                                value, "")
                            .catchError((e, s) {
                          print(e);
                        }),
                        builder: (context, snapshot) {
                          return SingleChildScrollView(
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FlexColumnWidth(8),
                                1: FlexColumnWidth(100 - 8 - 39),
                                2: FlexColumnWidth(13),
                                3: FlexColumnWidth(13),
                                4: FlexColumnWidth(13),
                              },
                              border: getIt<GlobalConfig>()
                                  .table_border, //color: Colors.transparent),
                              children: [
                                TableRow(children: [
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text("No.",
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text("name"),
                                  ),
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text("Price",
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text("QTY",
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                      padding: getIt<GlobalConfig>()
                                          .table_cell_padding,
                                      child: Container(height: 34)),
                                ]),
                                if (snapshot.data != null)
                                  ...snapshot.data!.entries.indexed.map((e) {
                                    var inventory = e.$2.value.item;
                                    return TableRow(children: [
                                      Padding(
                                        padding: getIt<GlobalConfig>()
                                            .table_cell_padding,
                                        child: Text((e.$1 + 1).toString() + ".",
                                            textAlign: TextAlign.right),
                                      ),
                                      Padding(
                                        padding: getIt<GlobalConfig>()
                                            .table_cell_padding,
                                        child: Text(
                                          inventory.productTemplate!.name +
                                              " " +
                                              inventory.productProperties!
                                                  .map((a) => " " + a.value)
                                                  .join("\u0020"),
                                        ),
                                      ),
                                      Padding(
                                        padding: getIt<GlobalConfig>()
                                            .table_cell_padding,
                                        child: Text(
                                            inventory.currentPrice.price
                                                .toString(),
                                            textAlign: TextAlign.right),
                                      ),
                                      Padding(
                                        padding: getIt<GlobalConfig>()
                                            .table_cell_padding,
                                        child: Text(e.$2.value.qty.toString(),
                                            textAlign: TextAlign.right),
                                      ),
                                      Padding(
                                        padding: getIt<GlobalConfig>()
                                            .table_cell_padding,
                                        child: ButtonBar(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                //double check
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text("\"" +
                                                          inventory
                                                              .productTemplate!
                                                              .name +
                                                          "  " +
                                                          inventory
                                                              .productProperties!
                                                              .map((a) =>
                                                                  " " + a.value)
                                                              .join("\u0020") +
                                                          "\" -1 ?"),
                                                      actions: [
                                                        OutlinedButton(
                                                            child:
                                                                Text("Cancel"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }),
                                                        OutlinedButton(
                                                          child: Text("Ok"),
                                                          onPressed: () {
                                                            getIt<OrderDao>()
                                                                .insert(Order(
                                                                    item:
                                                                        inventory,
                                                                    voucher: e
                                                                        .$2
                                                                        .value
                                                                        .voucher,
                                                                    orderStatus: e
                                                                        .$2
                                                                        .value
                                                                        .orderStatus,
                                                                    qty: -1))
                                                                .then(
                                                              (a) {
                                                                widget
                                                                    .controller
                                                                    .resetAllData();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {});
                                                              },
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                  Icons.exposure_minus_1_sharp,
                                                  color:
                                                      Colors.primaries.first),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]);
                                  }).toList()
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    //total price
                    Container(
                      height: getIt<GlobalConfig>().top_bar,
                      decoration: BoxDecoration(
                          border: Border(
                              top: getIt<GlobalConfig>().sepreate_border_side)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: getIt<GlobalConfig>().table_cell_padding,
                              child: Text("Total Price = ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: getIt<GlobalConfig>().table_cell_padding,
                              child: FutureBuilder(
                                  future: getIt<VoucherDao>().getTotalPrice(
                                      widget.controller.currentVoucher.value),
                                  builder: (context, snapshot) {
                                    return Text(
                                        snapshot.data != null
                                            ? snapshot.data.toString() +
                                                " Kyats "
                                            : "",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.right);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Future addVoucherOcDialog() {
    var data = OCDialogModel(
      title: "Add Voucher",
      error_message: widget.controller.addVoucherErrorMessage,
      cancel: widget.controller.resetAllData,
      ok: widget.controller.addVoucher,
      content: Container(
        width: 233,
        padding: EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Text("Table No."),
                ),
                FutureBuilder(
                    future: getIt<ServingTableDao>().searchWith_name_like(
                        widget.controller.ddSearchController.text),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return DropdownMenu<ServingTable>(
                          initialSelection: () {
                            if (snapshot.data!.length > 0) {
                              widget.controller.selectedTable =
                                  snapshot.data!.first;
                              return widget.controller.selectedTable;
                            }
                            return null;
                          }(),
                          onSelected: (a) {
                            widget.controller.selectedTable = a!;
                          },
                          dropdownMenuEntries: [
                            //if (snapshot.data!.length > 0)
                            for (var a = 0; a < snapshot.data!.length; a++)
                              DropdownMenuEntry(
                                  label: snapshot.data![a].name,
                                  value: snapshot.data![a]),
                          ],
                        );
                      }
                      return Container();
                    })
              ],
            ),
          ],
        ),
      ),
    );
    return showDialog(
        context: context,
        builder: (context) {
          return getIt<OCDialogComponent>().setData(data);
        });
  }
}
