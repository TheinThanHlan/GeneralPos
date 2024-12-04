import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './BuyController.dart';
import './Mobile.dart';
import './Desktop.dart';
import './Tablet.dart';

class BuyPage extends StatelessWidget implements IMVCView {
  late final BuyController controller;
  BuyPage(this.controller);
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        mobile: Mobile(controller: controller),
        tablet: Tablet(controller: controller));
  }
}
