import 'package:flutter/material.dart';

Widget responsiveLayout({
  required BuildContext context,
  required Widget desktop,
  required Widget mobile,
  required Widget tablet,
}) {
  double width = MediaQuery.of(context).size.width;
  //print(MediaQuery.of(context).size);
  if (width <= 700) {
    return mobile;
  }
  // if (width <= 800) {
  //   return tablet;
  // }
  else {
    return tablet;
  }
}
