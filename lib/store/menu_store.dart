import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/pages/app_menu/home.dart';
import 'package:stock_app/pages/app_menu/more_page.dart';

class AppMenuStore extends GetxController {
  int menuIndex = 0;

  Widget widget = const Home();

  List<Widget> widgetList = [const Home(), const MorePage()];

  void setAppMenuPage(int index) {
    menuIndex = index;
    widget = widgetList[menuIndex];
    print("widget : $widget");
    update();
  }
}
