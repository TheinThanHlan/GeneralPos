import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './SideBarController.dart';

class Mobile extends StatelessWidget {
  late final SideBarController controller;
  Mobile({required this.controller});

  Widget build(BuildContext context) {
    return Text(controller.greet);
  }

//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return _MobilePage();
//  }
}

//class _MobilePage extends State<MobilePage> {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Text(widget.controller.greet);
//  }
//}
