import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './OrderingController.dart';
import './Mobile.dart';
import './Desktop.dart';
import './Tablet.dart';

class OrderingPage extends StatelessWidget implements IMVCView {
  late final OrderingController controller;
  OrderingPage(this.controller);
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        mobile: Mobile(controller: controller),
        tablet: Tablet(controller: controller));
  }
}
