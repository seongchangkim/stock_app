import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:stock_app/dialog/error_dialog.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:stock_app/widgets/users/user_input_form.dart';
import 'package:stock_app/widgets/users/user_input_btn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late bool isAuth;
  late Future myFuture;

  final _loginFormKey = GlobalKey<FormState>();
  final _controller = Get.put(UserStore());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    width: width,
                    height: height,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "로그인",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          UserInputForm(
                              labelText: "이메일",
                              controller: emailController,
                              inputType: "email"),
                          UserInputForm(
                              labelText: "비밀번호",
                              controller: passwordController,
                              inputType: "password",
                              isMoveNextCursor: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("아직 회원이 아닙니까? "),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, '/signUpPage'),
                                  child: const Text(
                                    "회원가입",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: GestureDetector(
                                  onTap: () async {
                                    var params = {
                                      'email': emailController.text,
                                      'password': passwordController.text
                                    };

                                    if (_loginFormKey.currentState!
                                        .validate()) {
                                      var res = await signIn(params);

                                      var result = json.decode(res);
                                      // log("result : ${result.toString()}");
                                      print("result : ${result.runtimeType}");
                                      if (result["loginSuccess"]) {
                                        var res = await getProfileInfo();

                                        var result = json.decode(res);

                                        if (result['success']) {
                                          _controller
                                              .setUserInfo(result["user"]);
                                          _controller.loginCheck(true);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/appMenu',
                                              (_) => false);
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(content : result["message"]);
                                            });
                                      }
                                    }
                                  },
                                  child: UserInputBtn(
                                    text: "로그인",
                                    width: width * 0.8,
                                    backgroundColor: Colors.blueAccent,
                                  ))),
                        ],
                      ),
                    )))));
  }
}
