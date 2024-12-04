import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './VoucherHistoryController.dart';
import './Mobile.dart';
import './Desktop.dart';
import './Tablet.dart';

class VoucherHistoryPage extends StatelessWidget implements IMVCView {
  late final VoucherHistoryController controller;
  VoucherHistoryPage(this.controller) {
    print("haha");
    this.controller.isShowDetail = false;
  }
  @override
  Widget build(BuildContext context) {
    return responsiveLayout(
        context: context,
        desktop: Desktop(controller: controller),
        mobile: Mobile(controller: controller),
        tablet: Tablet(controller: controller));
  }
}
