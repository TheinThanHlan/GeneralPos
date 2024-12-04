import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './SideBarController.dart';
import './Mobile.dart';
import './Tablet.dart';
import './Desktop.dart';

class SideBarPage extends StatelessWidget implements IMVCView {
  late final SideBarController controller;
  SideBarPage(this.controller);
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        tablet: Tablet(controller: controller),
        mobile: Mobile(controller: controller));
  }
}
