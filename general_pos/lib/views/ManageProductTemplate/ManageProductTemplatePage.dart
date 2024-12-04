import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './ManageProductTemplateController.dart';
import './Mobile.dart';
import './Desktop.dart';
import './Tablet.dart';

class ManageProductTemplatePage extends StatelessWidget implements IMVCView {
  late final ManageProductTemplateController controller;
  ManageProductTemplatePage(this.controller);
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        mobile: Mobile(controller: controller),
        tablet: Tablet(controller: controller));
  }
}
