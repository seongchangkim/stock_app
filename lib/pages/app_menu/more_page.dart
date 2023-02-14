import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:stock_app/appBar/menu_select_appbar.dart';
import 'package:stock_app/global/user_global.dart';
import 'package:stock_app/store/menu_store.dart';
import 'package:stock_app/store/user_store.dart';

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
    // print("user : ${_userController.user}");
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
                        child: Column(children: [
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
                            onTap: () => Navigator.pushNamed(
                                context, '/myProfilePage',
                                arguments: {'user': _userController.user}),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("프로필",
                                          style: TextStyle(fontSize: 12)),
                                      Icon(Icons.arrow_forward_ios, size: 12)
                                    ],
                                  ),
                                )),
                          ),
                          GestureDetector(
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
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("로그아웃",
                                            style: TextStyle(fontSize: 12)),
                                        Icon(Icons.arrow_forward_ios, size: 12)
                                      ],
                                    ),
                                  )))
                        ]),
                      )
                    ],
                  ))),
        ));
  }
  
  @override
  bool get wantKeepAlive => true;
}
