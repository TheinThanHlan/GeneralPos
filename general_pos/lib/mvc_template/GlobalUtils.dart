import 'package:flutter/material.dart';
import 'package:general_pos/data/all.dart';

class GlobalUtils {
  String fDateTimeToDDMMYY_HMS(DateTime dt) {
    return dt.day.toString() +
        "/" +
        dt.month.toString() +
        "/" +
        dt.year.toString() +
        " " +
        dt.hour.toString() +
        ":" +
        dt.minute.toString() +
        ":" +
        dt.second.toString();
  }

  Padding vGap([double? size]) {
    return Padding(padding: EdgeInsets.symmetric(vertical: size ?? 5));
  }

  Padding hGap([double? size]) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: size ?? 5));
  }

  Future delay(int seconds) {
    return Future.delayed(Duration(seconds: seconds));
  }

  String inventory_string_formatter(Inventory i) {
    return i.productTemplate!.name +
        " " +
        i.productProperties!.map((e) => e.value).join(" ");
  }
}
