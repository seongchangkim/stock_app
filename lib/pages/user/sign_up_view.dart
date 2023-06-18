import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:stock_app/dialog/confirm_dialog.dart';
import 'package:stock_app/dialog/error_dialog.dart';
import 'package:stock_app/widgets/users/user_input_form.dart';
import 'package:stock_app/widgets/users/user_input_btn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: Colors.white24,
        elevation: 0, 
      ),
      body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
              key: _registerFormKey,
              child: Container(
                  width: _width,
                  height: _height * 0.9,
                  child: Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(_width * 0.1, _width * 0.1, _width * 0.1, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "회원가입",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              UserInputForm(
                                  labelText: "이메일",
                                  controller: _emailController,
                                  inputType: "email"),
                              UserInputForm(
                                  labelText: "비밀번호",
                                  controller: _passwordController,
                                  inputType: "password",
                                  isSignUpPasswordForm: true),
                              UserInputForm(
                                  labelText: "이름",
                                  controller: _nameController,
                                  inputType: "name"),
                              UserInputForm(
                                  labelText: "전화번호",
                                  controller: _telController,
                                  inputType: "tel",
                                  isMoveNextCursor: false,),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: GestureDetector(
                                    onTap: () async {
                                      var params = {
                                        'email': _emailController.text,
                                        'tel': _telController.text,
                                        'name': _nameController.text,
                                        'password': _passwordController.text
                                      };

                                      if (_registerFormKey.currentState!.validate()) {
                                        var res = await signUp(params);

                                        var result = json.decode(res);
                                        print("result : ${result.runtimeType}");
                                        if (result["success"]) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConfirmDialog(
                                                    title: "회원가입",
                                                    content: "회원가입 완료되었습니다.",
                                                    func: navigateLoginView);
                                              }
                                            );
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const ErrorDialog(content: "관리자에게 문의하세요!");
                                              }
                                          );
                                        }
                                      }
                                    },
                                    child: UserInputBtn(text: "회원가입", width: _width * 0.8, backgroundColor: Colors.blueAccent,) 
                                  )),
                            ],
                          )),
                    ],
                  )),
                ),
              ) 
            ));
  }

  void navigateLoginView() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/loginPage', (_) => false);
  }
}
