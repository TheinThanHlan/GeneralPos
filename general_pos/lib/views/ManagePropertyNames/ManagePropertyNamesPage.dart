import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './ManagePropertyNamesController.dart';
import './Mobile.dart';
import './Desktop.dart';
import './Tablet.dart';

class ManagePropertyNamesPage extends StatelessWidget implements IMVCView {
  late final ManagePropertyNamesController controller;
  ManagePropertyNamesPage(this.controller);
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        mobile: Mobile(controller: controller),
        tablet: Tablet(controller: controller));
  }
}
