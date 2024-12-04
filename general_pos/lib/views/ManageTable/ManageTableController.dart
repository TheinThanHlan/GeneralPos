import '../../mvc_template/abstract/MVCController.dart';
import 'package:flutter/widgets.dart';

class ManageTableController extends MVCController {
  ManageTableController();
  String greet = "Hello from ManageTablePage";
  ValueNotifier<String> ERROR_MESSAGE = ValueNotifier("");

  var searchController = TextEditingController();
}
