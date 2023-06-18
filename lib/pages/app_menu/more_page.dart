import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:stock_app/appBar/menu_select_appbar.dart';
import 'package:stock_app/global/user_global.dart';
import 'package:stock_app/store/menu_store.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:stock_app/widgets/more_page_container.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> with AutomaticKeepAliveClientMixin{
  final _userController = Get.put(UserStore());
  final _menuController = Get.put(AppMenuStore());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;

    return Scaffold(
        appBar: AppMenuAppBar(title: "더보기", appBar: AppBar(), color: Colors.white24,), 
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                  width: _width,
                  height: _height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 1.0))),
                        child: Column(
                          children: [
                            Container(
                              width: _width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text("계정 관리",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Navigator.pushNamed(
                                  context, '/myProfilePage',
                                  arguments: {'user': _userController.user}),
                              child: const MorePageContainer(text: "프로필 정보")
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                var params = {
                                  "userId": userId,
                                };

                                await logout(params).then(((value) async {
                                  _userController.setUserInfo({});
                                  _userController.loginCheck(false);
                                  _menuController.setAppMenuPage(0);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/loginPage', (route) => false);
                                }));
                              },
                              child: const MorePageContainer(text: "로그아웃")
                            )
                          ]),
                        )
                    ],
                  ))),
        ));
  }
  
  @override
  bool get wantKeepAlive => true;
}
