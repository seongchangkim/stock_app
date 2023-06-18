import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/store/menu_store.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppMenu extends StatefulWidget {
  const AppMenu({super.key});

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  final _menuController = Get.put(AppMenuStore());
  PageController _pageController = PageController();

  final List<BottomNavigationBarItem> _bottomMenuBarItemList = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.bars), label: '더보기'),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = _menuController.widgetList;
    int menuIndex = _menuController.menuIndex;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container( 
          child: PageView(
          onPageChanged: (index) {
            setState(() {
              menuIndex = index;
            });
          },
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: widgetList,
        ))),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomMenuBarItemList,
        currentIndex: menuIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {
          _pageController.jumpToPage(index);
          _menuController.setAppMenuPage(index);
        },
      ),
    );
  }
}
