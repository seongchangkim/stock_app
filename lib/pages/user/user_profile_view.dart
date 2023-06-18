import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:skeletons/skeletons.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_app/appbar/text_center_appbar.dart';
import 'package:stock_app/dialog/confirm_dialog.dart';
import 'package:stock_app/dialog/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:stock_app/widgets/users/user_input_btn_2.dart';
import 'package:get/get.dart';

class MyProfileView extends StatefulWidget {
  final dynamic user;

  const MyProfileView({super.key, required this.user});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  String _profileUrl = "";
  final ImagePicker _picker = ImagePicker();
  File? _previewFile;
  final storageRef = FirebaseStorage.instance.ref();
  final _controller = Get.put(UserStore());

  final _profileFormKey = GlobalKey<FormState>();

  final _telMaskFormatter = MaskTextInputFormatter(
      mask: '###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    _nameController.text = widget.user["name"];
    _telController.text = widget.user["tel"];
    _profileUrl = widget.user["profile_image"] ?? "";
    super.initState();
  }

  Future<bool> _updateLoginInfo() async {
    var res = await getProfileInfo();

    var result = json.decode(res);

    if (result['success']) {
      _controller.setUserInfo(result["user"]);
      _controller.loginCheck(true);
    }

    return _controller.isAuth;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;

    return Scaffold(
      appBar: TextCenterAppBar(title: "프로필 수정", appBar: AppBar()),
      body: SafeArea(
        child: Container(
          width: _width,
          height: _height,
          child: SingleChildScrollView(
            child: Form(
                key: _profileFormKey,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            XFile? file = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 100);

                            if (file == null) {
                              return;
                            }
                            setState(() {
                              _previewFile = File(file.path);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: ClipOval(
                                child: _profileUrl.isEmpty && _previewFile == null
                                    ? Image.asset(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                        'assets/default-user-profile.png')
                                    : (_previewFile == null
                                        ? Image.network(
                                            width: 100,
                                            height: 100,
                                            _profileUrl,
                                            fit: BoxFit.fill,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                child:
                                                  //   CircularProgressIndicator(
                                                  // value: loadingProgress
                                                  //             .expectedTotalBytes !=
                                                  //         null
                                                  //     ? loadingProgress
                                                  //             .cumulativeBytesLoaded /
                                                  //         loadingProgress
                                                  //             .expectedTotalBytes!
                                                  //     : null,
                                                  SkeletonAvatar(style: SkeletonAvatarStyle(height: 100, width: 100, shape: BoxShape.circle),)
                                                // ),
                                              );
                                            },
                                          )
                                        : Image.file(
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fill,
                                            _previewFile!))),
                          )),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "이름",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(156, 163, 175, 1)),
                                )),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                156, 163, 175, 1)))),
                                controller: _nameController,
                                validator: (text) {
                                  return (text!.trim().isEmpty)
                                      ? '이름을 입력하세요.'
                                      : null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "전화번호",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(156, 163, 175, 1)),
                                )),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                156, 163, 175, 1)))),
                                inputFormatters: [_telMaskFormatter],
                                controller: _telController,
                                validator: (text) {
                                  String pattern =
                                      '01[0|1|6|7|8|9]{1}-[0-9]{3,4}-[0-9]{4}';
                                  RegExp regExp = RegExp(pattern);
                                  if (text!.trim().isEmpty) {
                                    return '전화번호를 입력하세요.';
                                  } else if (!regExp
                                      .hasMatch(_telController.text)) {
                                    return '전화번호 형식에 맞게 입력하세요.';
                                  }

                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: _height * 0.05),
                        child: Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                                    onTap: () async {

                                      String? path = _previewFile != null
                                          ? _previewFile!.path
                                          : widget.user["profile_image"];

                                      if (_previewFile != null) {
                                        final mountainsRef = storageRef.child(
                                            "profiles/${widget.user["id"]}${_previewFile!.path.toString().substring(_previewFile!.path.toString().lastIndexOf('/'))}");

                                        // firebase storage에 이미지 업로드
                                        await mountainsRef
                                            .putFile(_previewFile!)
                                            .then((snapShot) async {
                                          // firebase storage 저장소 url 가져오기
                                          path = await snapShot.ref
                                              .getDownloadURL();
                                        });
                                      }

                                      var params = {
                                        'id': widget.user["id"],
                                        'profile_image': path ?? '',
                                        'name': _nameController.text,
                                        'tel': _telController.text,
                                      };

                                      if (_profileFormKey.currentState!
                                          .validate()) {
                                        var res =
                                            await updateProfileInfo(params);

                                        // print("res : ${res}");

                                        var result = json.decode(res);

                                        print("result : ${result}");

                                        if (result["success"]) {
                                          await _updateLoginInfo();
                                          print("sucess!!!");
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ConfirmDialog(
                                                  title: "프로필 수정",
                                                  content: "프로필 정보가 수정되었습니다.",
                                                  func: () =>
                                                      Navigator.pop(context));
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: const UserInputBtn2(text: "회원 수정", margin: EdgeInsets.only(right: 5.0), color: Color.fromRGBO(34, 211, 238, 1),))),
                            Expanded(
                                child: GestureDetector(
                                    onTap: () async {
                                      var params = {
                                        'ids': [widget.user["id"]].toString()
                                      };

                                      var res = await leaveUser(params);

                                      var result = json.decode(res);
                                      // log("result : ${result.toString()}");
                                      // print("result : ${result.runtimeType}");
                                      if (result["success"]) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ConfirmDialog(
                                                  title: "회원 탈퇴",
                                                  content: "회원 탈퇴되었습니다..",
                                                  func: () => Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/loginPage',
                                                          (_) => false));
                                            });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const ErrorDialog(content: "관리자에게 문의하세요.");
                                            });
                                      }
                                    },
                                    child: const UserInputBtn2(text: "회원 탈퇴", margin: EdgeInsets.only(left: 5.0), color: Color.fromRGBO(244, 63, 94, 1),)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      )),
    );
  }
}
