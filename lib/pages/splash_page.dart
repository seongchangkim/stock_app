import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:stock_app/global/user_global.dart';
import 'package:stock_app/store/menu_store.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:flutter/foundation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _userController = Get.put(UserStore());
  final _menuController = Get.put(AppMenuStore());
  late Future myFuture;

  @override
  void initState() {
    myFuture = _checkLogin();
    super.initState();
  }

  Future<void> _checkLogin() async {
    xAuthToken = await storage.read(key: 'x_auth') ?? '';
    userId = await storage.read(key: 'id') ?? '';

    Future.delayed(const Duration(seconds: kReleaseMode ? 1 : 0 ), () async{
      if (userId.isEmpty) {
        _userController.loginCheck(false);
        Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
        return;
      }

      var res = await getProfileInfo();

      var result = json.decode(res);

      if (result['success']) {
        _userController.setUserInfo(result["user"]);
        _userController.loginCheck(true);
        _menuController.setAppMenuPage(0);
        Navigator.pushNamedAndRemoveUntil(context, '/appMenu', (_) => false);
      } else {
        _userController.loginCheck(false);
        Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
      }
    });
   
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;

    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          return Container(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            width: _width,
            height: _height,
            child: const Center(
                child: Text("StockUp!",
                    style: TextStyle(fontSize: 24, color: Colors.white))),
          );
        },
      )),
    );
  }
}
