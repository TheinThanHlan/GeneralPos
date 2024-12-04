import 'package:flutter/material.dart';
import '../../mvc_template/all.dart';
import './SideBarController.dart';

class Tablet extends StatefulWidget {
  late final SideBarController controller;
  Tablet({required this.controller});

//  Widget build(BuildContext context) {
//    return Text(controller.greet);
//  }
  State<StatefulWidget> createState() {
    return _Tablet();
  }
}

class _Tablet extends State<Tablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 21,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widget.controller.isMenuFold
                    ? getIt<GlobalConfig>().sm_width
                    : getIt<GlobalConfig>().width,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: getIt<GlobalConfig>().sepreate_border_side),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: widget.controller.isMenuFold
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.controller.isMenuFold ? "" : "Menu",
                            style: getIt<GlobalConfig>().titleTextStyle,
                            textAlign: TextAlign.justify,
                          ),
                          IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                widget.controller.isMenuFold =
                                    !widget.controller.isMenuFold;
                                setState(() {});
                              })
                        ],
                      ),
                      if (!widget.controller.isMenuFold)
                        for (var a = 0; a < widget.controller.pages.length; a++)
                          ListTile(
                            onTap: () {
                              widget.controller.currentPage =
                                  widget.controller.pages[a];
                              setState(() {});
                            },
                            leading: Icon(widget.controller.pages[a]['icon']),
                            title: Text(widget.controller.pages[a]['name'],
                                style: getIt<GlobalConfig>().textStyle),
                            selected: widget.controller.pages[a] ==
                                widget.controller.currentPage,
                          )
                      else if (widget.controller.isMenuFold)
                        for (var a = 0; a < widget.controller.pages.length; a++)
                          IconButton(
                              onPressed: () {
                                widget.controller.currentPage =
                                    widget.controller.pages[a];
                                setState(() {});
                              },
                              icon: Icon(widget.controller.pages[a]['icon']),
                              color: widget.controller.pages[a] ==
                                      widget.controller.currentPage
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).unselectedWidgetColor)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: widget.controller.currentPage["page"](),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
