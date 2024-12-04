import '../interface/IMVCView.dart';

abstract class MVCController<V extends IMVCView> {
  //late final IMVCView view;
  //late final IMVCDao dao;
  late final V view;
  // MVCController({required this.view}) {
  //   view.controller = this;
  // }
}
