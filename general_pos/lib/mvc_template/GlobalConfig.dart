import 'package:flutter/widgets.dart';

class GlobalConfig {
  final double padding_1 = 21;
  final double top_bar = 55;
  final textStyle = TextStyle(fontSize: 13);
  final warningTextStyle =
      TextStyle(fontSize: 12, color: Color.fromARGB(225, 225, 0, 0));
  final titleTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  final double width = 144;
  final double sm_width = 55;
  final BorderSide sepreate_border_side = BorderSide(
      color: Color.fromARGB(89, 92, 92, 92),
      width: 1,
      style: BorderStyle.solid);

  final TableBorder table_border = TableBorder.all(
    color: Color.fromARGB(89, 92, 92, 92),
    width: 0.5,
    style: BorderStyle.solid,
  );
  final table_cell_padding = EdgeInsets.only(right: 2, left: 2);
  final double text_box_height = 55;
}
