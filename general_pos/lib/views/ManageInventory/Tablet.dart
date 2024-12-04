import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './ManageInventoryController.dart';
import '../Components/OCDialog/OCDialogModel.dart';
import '../Components/OCDialog/OCDialogComponent.dart';
import '../../data/all.dart';

class Tablet extends StatefulWidget {
  late final ManageInventoryController controller;
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 13,
          //top buttons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 144,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextFormField(
                  controller: widget.controller.searchController,
                  //get the keyboard events
                  onChanged: (x) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    label: Text("Search/Add",
                        style: getIt<GlobalConfig>().textStyle),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  child: OutlinedButton(
                    onPressed: () {
                      //widget.controller.addProductTemplate();
                      if (!widget.controller.searchController.text.isEmpty) {
                        getIt<ProductTemplateDao>()
                            .searchWithName(
                                widget.controller.searchController.text)
                            .then((x) {
                          if (x.length == 0) {
                            openAddProductTemplateOcDialog().then((a) {
                              setState(() {});
                            });
                          }
                        });
                      }
                    },
                    child: Text("Register Product"),
                  ),
                ),
              ),
              if (widget.controller.currentProductTemplateIdNoti.value != 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    child: OutlinedButton(
                      onPressed: () {
                        if (widget.controller.addEditTmpInventory
                                .productTemplate !=
                            null) {
                          openAddInventoryOCDialog().then((_) {
                            widget.controller.resetData();
                            //int tmp = widget
                            //    .controller.currentProductTemplateIdNoti.value;
                            //widget.controller.currentProductTemplateIdNoti.value =
                            //    10;
                            //widget.controller.currentProductTemplateIdNoti.value =
                            //    tmp;
                            setState(() {});
                          });
                        }
                      },
                      child: Text("Register Inventory"),
                    ),
                  ),
                ),
            ],
          ),
        ),
        //warning message
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerLeft,
            child: widget.controller.searchController.text.isNotEmpty
                ? Text("ရှာဖွေ ထားသော ရလဒ်များ",
                    style: TextStyle(color: Colors.green))
                : Container(),
          ),
        ),
        Expanded(
          flex: 100 - 13 - 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //product templates
              FutureBuilder(
                future: getIt<ProductTemplateDao>().readAllWithSearch(
                    search: widget.controller.searchController.text),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.data != null) {
                    if (dataSnapshot.data!.isNotEmpty &&
                        widget.controller.addEditTmpInventory.productTemplate ==
                            null) {
                      widget.controller.addEditTmpInventory.productTemplate =
                          dataSnapshot.data!.values.first;
                    }
                    return Container(
                      width: 180,
                      child: ListView(
                        children: dataSnapshot.data!.entries.map(
                          (a) {
                            return ListTile(
                                title: Text(a.value.name,
                                    style: TextStyle(fontSize: 13)),
                                trailing: Icon(Icons.arrow_right),
                                onTap: () {
                                  widget.controller.currentProductTemplateIdNoti
                                      .value = a.key;
                                  widget.controller.addEditTmpInventory
                                      .productTemplate = a.value;
                                  setState(() {});
                                },
                                selected: a.key ==
                                    widget.controller
                                        .currentProductTemplateIdNoti.value);
                          },
                        ).toList(),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              ValueListenableBuilder(
                valueListenable: widget.controller.currentProductTemplateIdNoti,
                builder: (context, value, child) {
                  return FutureBuilder(
                      future: getIt<InventoryDao>()
                          .readFromProductTemplateId(value),
                      builder: (context, snapshot) {
                        if (snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          return Expanded(
                              flex: 100 - 34,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Table(
                                  border: getIt<GlobalConfig>().table_border,
                                  columnWidths: {
                                    0: FlexColumnWidth(8),
                                    1: FlexColumnWidth(55),
                                    2: FlexColumnWidth(100 - 63 - 21),
                                    3: FlexColumnWidth(34),
                                  },
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                          child: Text("No.",
                                              textAlign: TextAlign.center),
                                          verticalAlignment:
                                              TableCellVerticalAlignment
                                                  .middle),
                                      TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text(
                                            " Property",
                                          )),
                                      TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text("Price",
                                              textAlign: TextAlign.center)),
                                      TableCell(child: Container(height: 34))
                                    ]),
                                    ...snapshot.data!.indexed.map(
                                      (j) {
                                        var (index, a) = j;
                                        return TableRow(
                                          children: [
                                            TableCell(
                                              child: Text(
                                                  (index + 1).toString() + ".",
                                                  textAlign: TextAlign.right),
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                            ),
                                            TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Table(
                                                columnWidths: {
                                                  0: FlexColumnWidth(34),
                                                  1: FlexColumnWidth(3),
                                                  2: FlexColumnWidth(
                                                      100 - 34 - 3)
                                                },
                                                defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                children: [
                                                  ...a.productProperties!.map(
                                                    (b) => TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        8),
                                                            child: Text(b
                                                                .productPropertyName
                                                                .name),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child: Text("="),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              b.value,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //UPC
                                                  if (a.UPC != null)
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        8),
                                                            child: Text("UPC"),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child: Text("="),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        8),
                                                            child: Text(a.UPC!),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  //SKU
                                                  if (a.SKU != null)
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        8),
                                                            child: Text("SKU"),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8),
                                                            child: Text("="),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1,
                                                                    vertical:
                                                                        8),
                                                            child: Text(a.SKU!),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Text(
                                                    a.currentPrice.price
                                                        .toString(),
                                                    textAlign: TextAlign.end)),
                                            TableCell(
                                                child: ButtonBar(children: [
                                              //delete Inventory
                                              IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    getIt<InventoryDao>()
                                                        .delete(a.id!)
                                                        .then((x) {
                                                      setState(() {});
                                                    });
                                                  }),
                                              //edit the price of the product
                                              IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          var tmpTextControllerForPriceChange =
                                                              TextEditingController();
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Change Price"),
                                                            content: TextFormField(
                                                                controller:
                                                                    tmpTextControllerForPriceChange,
                                                                decoration: InputDecoration(
                                                                    label: Text(
                                                                        "Price"))),
                                                            actions: [
                                                              ButtonBar(
                                                                children: [
                                                                  OutlinedButton(
                                                                      child: Text(
                                                                          "cancel"),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      }),
                                                                  OutlinedButton(
                                                                      child: Text(
                                                                          "Ok"),
                                                                      onPressed:
                                                                          () {
                                                                        if (tmpTextControllerForPriceChange
                                                                            .text
                                                                            .isNotEmpty) {
                                                                          getIt<ProductPriceDao>()
                                                                              .addNewPrice(
                                                                            ProductPrice(
                                                                                price: int.parse(tmpTextControllerForPriceChange.text),
                                                                                Inventory_mappedBy_prices: a),
                                                                          )
                                                                              .then((_) {
                                                                            Navigator.of(context).pop();
                                                                            setState(() {});
                                                                          });
                                                                        }
                                                                      }),
                                                                ],
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  }),
                                            ])),
                                          ],
                                        );
                                      },
                                    ).toList()
                                  ],
                                ),
                              ));
                        }
                        return Container();
                      });

                  /*
                  */
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future openAddInventoryOCDialog() {
    double tbl_col_padding = 8;
    var model = OCDialogModel(
      cancel: widget.controller.resetData,
      error_message: widget.controller.addErrorMessage,
      title: "Inventory Item",
      ok: widget.controller.addInventory,
      content: SizedBox(
        width: 320,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13),
          child: Column(
            children: [
              Text(
                  "Add Inventory For '${widget.controller.addEditTmpInventory.productTemplate!.name}'"),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tbl_col_padding),
                        child: Text("Price"),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tbl_col_padding),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (a) {
                            try {
                              widget.controller.addEditTmpInventory.currentPrice
                                  .price = int.parse(a);
                            } on FormatException catch (e) {}
                          },
                          decoration: InputDecoration(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tbl_col_padding),
                        child: Text("Bar Code (UPC)"),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tbl_col_padding),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (a) {
                            widget.controller.addEditTmpInventory.UPC =
                                a.trim().replaceAll(" ", "");
                          },
                          decoration: InputDecoration(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tbl_col_padding),
                        child: Text("Custom Bar Code (SKU)"),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: tbl_col_padding),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (a) {
                            widget.controller.addEditTmpInventory.SKU =
                                a.trim().replaceAll(" ", "");
                          },
                          decoration: InputDecoration(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatefulBuilder(
                builder: (context, state) {
                  ValueNotifier<ProductProperty> tmpProductProperty =
                      ValueNotifier(ProductProperty(
                          id: 0,
                          productPropertyName:
                              ProductPropertyName(id: 0, name: ""),
                          value: ""));
                  return Column(
                    children: [
                      Row(
                        children: [
                          //product property name
                          Expanded(
                            child: FutureBuilder(
                              future: getIt<ProductPropertyNameDao>()
                                  .readExclude(widget.controller
                                      .addEditTmpInventory.productProperties!
                                      .map((a) => a.productPropertyName)
                                      .toList()),
                              builder: (context, dataSnapshot) {
                                return DropdownMenu(
                                  onSelected: (a) {
                                    if (a != null) {
                                      tmpProductProperty.value =
                                          ProductProperty(
                                              id: 0,
                                              productPropertyName: a,
                                              value: "");
                                    }
                                  },
                                  dropdownMenuEntries: [
                                    if (dataSnapshot.data != null)
                                      ...dataSnapshot.data!.map(
                                        (a) {
                                          return DropdownMenuEntry(
                                              label: a.name, value: a);
                                        },
                                      ).toList(),
                                  ],
                                );
                              },
                            ),
                          ),
                          //product property value
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: tmpProductProperty,
                              builder: (context, value, child) => FutureBuilder(
                                future: getIt<ProductPropertyDao>()
                                    .readFromProductPropertyName(
                                        value.productPropertyName),
                                builder: (context, dataSnapshot) {
                                  return DropdownMenu<ProductProperty>(
                                    initialSelection: null,
                                    onSelected: (x) {
                                      if (x != null) {
                                        tmpProductProperty.value = x;
                                      }
                                    },
                                    dropdownMenuEntries: [
                                      if (dataSnapshot.data != null)
                                        ...dataSnapshot.data!.map(
                                          (a) {
                                            return DropdownMenuEntry(
                                                label: a.value, value: a);
                                          },
                                        ).toList(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (tmpProductProperty.value.id != 0) {
                                widget.controller.addEditTmpInventory
                                    .productProperties!
                                    .add(tmpProductProperty.value);

                                tmpProductProperty.value = ProductProperty(
                                  id: 0,
                                  productPropertyName:
                                      ProductPropertyName(name: ""),
                                  value: "",
                                );
                                state(() {});
                              }
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      DataTable(
                        columns: [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Value")),
                          DataColumn(label: Text("")),
                        ],
                        rows: [
                          for (var a = 0;
                              a <
                                  widget.controller.addEditTmpInventory
                                      .productProperties!.length;
                              a++)
                            DataRow(
                              cells: [
                                DataCell(Text(widget
                                    .controller
                                    .addEditTmpInventory
                                    .productProperties![a]
                                    .productPropertyName
                                    .name)),
                                DataCell(Text(widget
                                    .controller
                                    .addEditTmpInventory
                                    .productProperties![a]
                                    .value)),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      widget.controller.addEditTmpInventory
                                          .productProperties!
                                          .removeAt(a);
                                      state(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    return showDialog(
        context: context,
        builder: (context) {
          return getIt<OCDialogComponent>().setData(model);
        });
  }

  Future openAddProductTemplateOcDialog() {
    var model = OCDialogModel(
      cancel: widget.controller.resetData,
      error_message: widget.controller.showDialogErrorMessage,
      title: "Product Type",
      ok: widget.controller.addProductTemplate,
      content: Container(
        width: 233,
        padding: EdgeInsets.symmetric(vertical: 34),
        child: StatefulBuilder(
          builder: (context, state) {
            return Column(
              children: [
                FutureBuilder(
                  future: getIt<ProductCategoryDao>().readExclude(
                      widget.controller.addEditTmpProductTemplate.categories ??
                          []),
                  builder: (context, dataSnapshot) {
                    if (dataSnapshot.data != null) {
                      return Container(
                        height: 89,
                        width: 233,
                        child: ListView.builder(
                          itemCount: dataSnapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                dataSnapshot.data![index].name,
                                style: TextStyle(fontSize: 13),
                              ),
                              onTap: () {
                                widget.controller.addEditTmpProductTemplate
                                    .categories!
                                    .add(dataSnapshot.data![index]);
                                state(() {});
                              },
                              trailing: Icon(Icons.add),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Container(
                  child: Text("Choosed Product Types",
                      style: TextStyle(fontSize: 10)),
                ),
                Container(
                  height: 89,
                  width: 233,
                  child: ListView.builder(
                    itemCount: widget.controller.addEditTmpProductTemplate
                        .categories!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          widget
                              .controller.addEditTmpProductTemplate.categories!
                              .removeAt(index);
                          state(() {});
                        },
                        title: Text(
                          widget.controller.addEditTmpProductTemplate
                              .categories![index].name,
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: Icon(Icons.remove),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
    return showDialog(
        context: context,
        builder: (context) {
          return getIt<OCDialogComponent>().setData(model);
        });
  }
}
