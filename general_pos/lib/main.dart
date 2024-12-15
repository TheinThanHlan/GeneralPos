import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:general_pos/views/SideBar/SideBarPage.dart';
import 'mvc_template/all.dart';
import "package:flutter/services.dart";

ThemeData globalTheme = ThemeData(fontFamilyFallback: ["OpenSans", "mm3"]);

void main() {
  init().then((x) {
    MaterialApp mainApp = MaterialApp(
      home: SafeArea(child: getIt<SideBarPage>()),
      useInheritedMediaQuery: true,
      theme: globalTheme,
      debugShowCheckedModeBanner: false,
    );
    //runApp(mainApp);
    runApp(
      //un comment this if you want to release
      //mainApp
      DevicePreview(builder: (context) => mainApp),
    );
  });
}
