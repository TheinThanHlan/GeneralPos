import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './BuyController.dart';
import '../../data/all.dart';

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
                                    widget.controller.resetData();
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
              if (value != null) {
                return Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: getIt<GlobalConfig>().top_bar,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    right: getIt<GlobalConfig>().padding_1),
                                child: OutlinedButton(
                                  child: Text("Add Order"),
                                  onPressed: () {
                                    openAddOrderDialog();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              }
              return Container();
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
                      widget.controller.resetData();
                      Navigator.of(context).pop();
                    }),
                OutlinedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      widget.controller.addVoucher().then((x) {
                        widget.controller.resetData();
                        Navigator.of(context).pop();
                      });
                    }),
              ]);
        });
  }

  //Order adding noti dialog
  Future<void> openAddOrderDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Order ပစ္စည်း အားရွေးချယ်ပါ"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //choose products
                  Container(
                    height: getIt<GlobalConfig>().text_box_height,
                    child: FutureBuilder(
                        future: getIt<ProductTemplateDao>().readAll(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            return DropdownMenu(
                                width: double.maxFinite - 200,
                                menuHeight: 144,
                                label: Text("ကုန်စည်"),
                                dropdownMenuEntries: snapshot.data!.map((e) {
                                  return DropdownMenuEntry(
                                      label: e.name, value: e);
                                }).toList());
                          }
                          return Container();
                        }),
                  ),
                  //choose size or something.
                  ValueListenableBuilder(
                      valueListenable: widget.controller.currentProductTemplate,
                      builder: (context, value, child) {
                        return Container(
                          height: getIt<GlobalConfig>().text_box_height,
                          child: FutureBuilder(
                              future: getIt<InventoryDao>()
                                  .readFromProductTemplateId(value.id!),
                              builder: (context, snapshot) {
                                if (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty) {
                                  return DropdownMenu(
                                      menuHeight: 144,
                                      label: Text("select oroperties"),
                                      dropdownMenuEntries:
                                          snapshot.data!.map((e) {
                                        return DropdownMenuEntry(
                                            label: "hi", value: e);
                                      }).toList());
                                }
                                return Container();
                              }),
                        );
                      })
                ],
              ),
              actions: [
                OutlinedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      widget.controller.resetData();
                      Navigator.of(context).pop();
                    }),
                OutlinedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      widget.controller.addVoucher().then((x) {
                        widget.controller.resetData();
                        Navigator.of(context).pop();
                      });
                    }),
              ]);
        });
  }
}
