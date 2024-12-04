import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './BuyController.dart';

class Mobile extends StatelessWidget {
  late final BuyController controller;
  Mobile({required this.controller});

  Widget build(BuildContext context) {
    return Text(controller.greet);
  }

//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return _Mobile();
//  }
}

//class _Mobile extends State<Mobile> {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Text(widget.controller.greet);
//  }
//}
