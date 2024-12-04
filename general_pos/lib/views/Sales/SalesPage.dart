import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './SalesController.dart';
import './Mobile.dart';
import './Desktop.dart';
import './Tablet.dart';

class SalesPage extends StatelessWidget implements IMVCView {
  late final SalesController controller;
  SalesPage(this.controller);
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        mobile: Mobile(controller: controller),
        tablet: Tablet(controller: controller));
  }
}
