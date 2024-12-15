import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './BuyController.dart';
import '../../data/all.dart';
import '../Ordering/all.dart';
import 'package:data_table_2/data_table_2.dart';

class Tablet extends StatefulWidget {
  late final BuyController controller;
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
          width: getIt<GlobalConfig>().width,
          decoration: BoxDecoration(
            border: Border(right: getIt<GlobalConfig>().sepreate_border_side),
          ),
          child: Column(
            children: [
              //add Voucher Button
              Container(
                padding: EdgeInsets.only(
                  top: getIt<GlobalConfig>().padding_1,
                  bottom: getIt<GlobalConfig>().padding_1,
                ),
                child: OutlinedButton(
                  child: Text("Add Voucher", style: TextStyle(fontSize: 13)),
                  onPressed: () {
                    openAddVoucherDialog().then((_) {
                      setState(() {});
                    });
                    //widget.controller.addVoucher();
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getIt<VoucherDao>().search(Voucher(
                    table: ServingTable(name: ''),
                    totalPrice: 0,
                    discount: 0,
                    status: VoucherStatus(name: ""),
                    type: VoucherType(id: 2, name: ""),
                  )),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return StatefulBuilder(
                        builder: (context, voucherListViewSetState) {
                          return ListView(
                            children: [
                              for (var a = 0; a < snapshot.data!.length; a++)
                                ListTile(
                                  selected: widget.controller.currentVoucher
                                          .value?.id ==
                                      snapshot.data![a].id,
                                  title: Text(
                                      snapshot.data![a].name != ""
                                          ? snapshot.data![a].name!
                                          : getIt<GlobalUtils>()
                                              .fDateTimeToDDMMYY_HMS(snapshot
                                                  .data![a].openedTime!),
                                      style: getIt<GlobalConfig>().textStyle),
                                  onTap: () {
                                    widget.controller.currentVoucher.value =
                                        snapshot.data![a];
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
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
            valueListenable: widget.controller.currentVoucher,
            builder: (context, value, child) {
              if (value != null && value.id != 0) {
                return Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: getIt<GlobalConfig>().top_bar,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                              "ဘောင်ချာအား ပိတ်မည် \n Close voucher"),
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
                                                    .closeVoucherIfAllOrderStatusIs(
                                                        widget
                                                            .controller
                                                            .currentVoucher
                                                            .value!,
                                                        6)
                                                    .then(
                                                  (a) {
                                                    if (a != 0) {
                                                      widget
                                                          .controller
                                                          .currentVoucher
                                                          .value = Voucher(
                                                        id: 0,
                                                        totalPrice: 0,
                                                        discount: 0,
                                                        status: VoucherStatus(
                                                            name: ""),
                                                        type: VoucherType(
                                                            id: 0, name: ""),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Order အားလုံး ငွေရှင်းပြီးမှသာ Voucher အားပိတ်ရန် ခွင့်ပြုသည်။")));
                                                    }
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
                                //add order button
                                Container(
                                  padding: EdgeInsets.only(
                                      right: getIt<GlobalConfig>().padding_1),
                                  child: OutlinedButton(
                                    child: Text("Order"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              getIt<OrderingPage>(
                                            param1: OrderingModel(
                                                currentVoucher: value),
                                          ),
                                        ),
                                      )
                                          .then((_) {
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        //add
                        FutureBuilder(
                          future: getIt<OrderDao>()
                              .readOrdersWith_voucher_searchWith_productTemplateName2(
                                  value, ""),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              List<TableRow> row = [];
                              List<Order> tmpData = snapshot.data ?? [];
                              for (int a = 0; a < snapshot.data!.length; a++) {
                                row.add(TableRow(children: [
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text((a + 1).toString() + ".",
                                        textAlign: TextAlign.end),
                                  ),
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text(getIt<GlobalUtils>()
                                        .inventory_string_formatter(
                                            tmpData[a].item)),
                                  ),
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text(tmpData[a].qty.toString(),
                                        textAlign: TextAlign.end),
                                  ),
                                  TextButton(
                                    child: Text(tmpData[a].orderStatus.name),
                                    onPressed: () {
                                      int nextOrderStatus = widget.controller
                                          .getNextStatusStep(tmpData[a]);
                                      if (nextOrderStatus != 0) {
                                        if (nextOrderStatus ==
                                            widget.controller.orderStatusSteps
                                                .last) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                          controller: widget
                                                              .controller
                                                              .buyPriceInputController,
                                                          decoration:
                                                              InputDecoration(
                                                            label: Text(
                                                                "ကုန်စည် တစ်ခု ဝယ်စျေး"),
                                                            //textinput clear text
                                                          ),
                                                        ),
                                                      ]),
                                                  actions: [
                                                    TextButton(
                                                      child: Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        if (widget
                                                            .controller
                                                            .buyPriceInputController
                                                            .text
                                                            .isNotEmpty) {
                                                          getIt<OrderDao>()
                                                              .updateBuyPrice(
                                                                  tmpData[a],
                                                                  widget
                                                                      .controller
                                                                      .buyPriceInputController
                                                                      .text)
                                                              .then((_) {
                                                            getIt<OrderDao>()
                                                                .changeOrderStatus(
                                                              tmpData[a],
                                                              nextOrderStatus,
                                                            )
                                                                .then((_) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {});
                                                            });
                                                          });
                                                        }
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        } else {
                                          getIt<OrderDao>()
                                              .changeOrderStatus(
                                            tmpData[a],
                                            nextOrderStatus,
                                          )
                                              .then((_) {
                                            setState(() {});
                                          });
                                        }
                                      } else {}
                                    },
                                  ),
                                  ButtonBar(children: [
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {}),
                                  ]),
                                ]));
                              }
                              return Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(54),
                                      1: FlexColumnWidth(54),
                                      2: FixedColumnWidth(54),
                                      3: FixedColumnWidth(144),
                                      4: FixedColumnWidth(54),
                                    },
                                    border: getIt<GlobalConfig>().table_border,
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(
                                        children: [
                                          //table heading
                                          Padding(
                                            padding: getIt<GlobalConfig>()
                                                .table_cell_padding,
                                            child: Text(
                                              "စဉ်",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: getIt<GlobalConfig>()
                                                .table_cell_padding,
                                            child: Text(
                                              "ကုန်ပစ္စည်း အမည်",
                                            ),
                                          ),
                                          Padding(
                                            padding: getIt<GlobalConfig>()
                                                .table_cell_padding,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "Qty.",
                                            ),
                                          ),
                                          Padding(
                                            padding: getIt<GlobalConfig>()
                                                .table_cell_padding,
                                            child: Text(
                                              "Status",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            height: 34,
                                          ),
                                        ],
                                      ),

                                      //orders
                                      ...row
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Expanded(child: Container());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Expanded(child: Container());
            }),
      ],
    );
  }

  //voucher adding noti dialog
  Future<void> openAddVoucherDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Order voucher အသစ် ဖွင့်ရန်"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Voucher name အား မဖြည့်လဲရသည်။"),
                  Container(
                    height: getIt<GlobalConfig>().text_box_height,
                    child: TextFormField(
                      controller: widget.controller.voucherNameInputController,
                      //get the keyboard events
                      onChanged: (x) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        label: Text("Voucher name"),
                        //textinput clear text

                        suffixIcon: InkWell(
                          child: Icon(Icons.clear),
                          onTap: () {
                            widget.controller.voucherNameInputController
                                .clear();
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                OutlinedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                OutlinedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      widget.controller.addVoucher().then((x) {
                        Navigator.of(context).pop();
                      });
                    }),
              ]);
        });
  }
}
