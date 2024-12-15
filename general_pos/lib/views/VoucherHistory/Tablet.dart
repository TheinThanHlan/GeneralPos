import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './VoucherHistoryController.dart';
import '../../data/all.dart';

class Tablet extends StatefulWidget {
  late final VoucherHistoryController controller;
  Tablet({required this.controller});

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Tablet();
  }
}

class _Tablet extends State<Tablet> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: getIt<GlobalConfig>().padding_1),
          alignment: Alignment.centerLeft,
          child: Text(
            "Voucher History",
            style: getIt<GlobalConfig>().titleTextStyle,
          ),
          height: getIt<GlobalConfig>().top_bar,
        ),
        //show list of vouchers
        if (!widget.controller.isShowDetail)
          FutureBuilder(
            future: getIt<VoucherDao>()
                .readClosedVouchers()
                .catchError((e) => print(e)),
            builder: (context, snapshot) {
              return Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.maxFinite,
                  child: DataTable(
                    border: getIt<GlobalConfig>().table_border,
                    columns: [
                      DataColumn(label: Text("No."), numeric: true),
                      DataColumn(label: Text("Date Time")),
                      DataColumn(label: Text("Type")),
                      DataColumn(label: Text("Total")),
                      DataColumn(label: Text("Details")),
                    ],
                    rows: [
                      if (snapshot.data != null)
                        for (int a = 0; a < snapshot.data!.length; a++)
                          DataRow(cells: [
                            DataCell(Text((a + 1).toString())),
                            DataCell(Text(getIt<GlobalUtils>()
                                .fDateTimeToDDMMYY_HMS(
                                    snapshot.data![a].closedTime!))),
                            DataCell(
                                Text(snapshot.data![a].type.name.toString())),
                            DataCell(
                                Text(snapshot.data![a].totalPrice.toString())),
                            DataCell(IconButton(
                                onPressed: () {
                                  widget.controller.isShowDetail = true;
                                  widget.controller.listenableVoucher.value =
                                      snapshot.data![a];
                                  setState(() {});
                                },
                                icon: Icon(Icons.file_open)))
                          ])
                    ],
                  ),
                ),
              ));
            },
          ),
        //voucher Detail
        if (widget.controller.isShowDetail)
          ValueListenableBuilder(
              valueListenable: widget.controller.listenableVoucher,
              builder: (context, value, child) {
                return Column(
                  children: [
                    //top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: getIt<GlobalConfig>().padding_1),
                          //back button
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              widget.controller.isShowDetail = false;
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          child: Text(value.table!.name + " " + value.name!,
                              style: getIt<GlobalConfig>().titleTextStyle),
                          padding: EdgeInsets.only(
                              left: getIt<GlobalConfig>().padding_1),
                        ),
                        Container(
                          child: Text(
                              value.closedTime!.day.toString() +
                                  "/" +
                                  value.closedTime!.month.toString() +
                                  "/" +
                                  value.closedTime!.year.toString() +
                                  " " +
                                  value.closedTime!.hour.toString() +
                                  ":" +
                                  value.closedTime!.minute.toString() +
                                  ":" +
                                  value.closedTime!.second.toString(),
                              style: getIt<GlobalConfig>().titleTextStyle),
                          padding: EdgeInsets.only(
                              left: getIt<GlobalConfig>().padding_1),
                        ),
                        Container(
                          child: Text(
                              "စုစုပေါင်း = " +
                                  value.totalPrice.toString() +
                                  " ကျပ်",
                              style: getIt<GlobalConfig>().titleTextStyle),
                          padding: EdgeInsets.only(
                              left: getIt<GlobalConfig>().padding_1),
                        ),
                      ],
                    ),
                    //item lists
                    FutureBuilder(
                        future: getIt<OrderDao>()
                            .readOrdersWith_voucher_searchWith_productTemplateName(
                                value, ""),
                        builder: (context, snapshot) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FlexColumnWidth(8),
                                1: FlexColumnWidth(100 - 8 - 42),
                                2: FlexColumnWidth(21),
                                3: FlexColumnWidth(21),
                              },
                              border: getIt<GlobalConfig>()
                                  .table_border, //color: Colors.transparent),
                              children: [
                                TableRow(children: [
                                  Container(
                                    height: 40,
                                    alignment: Alignment.center,
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
                                    child: Text(value.type.name + "စျေး",
                                        textAlign: TextAlign.center),
                                  ),
                                  Padding(
                                    padding: getIt<GlobalConfig>()
                                        .table_cell_padding,
                                    child: Text("QTY",
                                        textAlign: TextAlign.center),
                                  ),
                                ]),
                                if (snapshot.data != null)
                                  ...snapshot.data!.entries.indexed.map((e) {
                                    var inventory = e.$2.value.item;
                                    return TableRow(children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        height: 30,
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
                                            (e.$2.value.buyPrice ??
                                                    inventory
                                                        .currentPrice.price)
                                                .toString(),
                                            textAlign: TextAlign.right),
                                      ),
                                      Padding(
                                        padding: getIt<GlobalConfig>()
                                            .table_cell_padding,
                                        child: Text(e.$2.value.qty.toString(),
                                            textAlign: TextAlign.right),
                                      ),
                                    ]);
                                  }).toList()
                              ],
                            ),
                          );
                        })
                  ],
                );
              }),
      ],
    );
  }
}
