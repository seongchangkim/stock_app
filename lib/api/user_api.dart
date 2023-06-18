import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_app/global/user_global.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:get/get.dart';
import 'package:stock_app/global/env/env.dart';

// 공통 URL 가져오기
const baseUrl = Env.baseUrl;

final _userController = Get.put(UserStore());

// 회원가입
Future<dynamic> signUp(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/user/register");
  var res = await http.post(uri, body: params);

  return res.body;
}

// 로그인
Future<dynamic> signIn(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/user/login");
  var res = await http.post(uri, body: params);
  
  var data = json.decode(res.body);

  await storage
      .write(key: 'x_auth', value: data["xAuthToken"])
      .then((value) async {
    xAuthToken = await storage.read(key: 'x_auth') ?? '';
  });

  await storage.write(key: 'id', value: data["userId"]).then((value) async {
    userId = await storage.read(key: 'id') ?? '';
  });

  return res.body;
}

// 로그아웃
Future<dynamic> logout(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/user/logout");
  var res = await http.post(uri, body: params);

  await storage.delete(key: 'x_auth');
  await storage.delete(key: 'id');
  userId = "";
  return res.body;
}

// 로그인 여부 확인
Future<dynamic> checkAuth() async {
  Uri uri = Uri.parse("${baseUrl}api/users/auth");
  var res = await http.get(uri);

  return res.body;
}

// 프로필 정보 가져오기
Future<dynamic> getProfileInfo() async {
  Uri uri = Uri.parse("${baseUrl}api/user/profile/show?id=$userId");
  var res = await http.get(uri);

  return res.body;
}

// 프로필 정보 수정
Future<dynamic> updateProfileInfo(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/user/profile/edit");
  var res = await http.patch(uri, body: params);

  return res.body;
}

// 회원 탈퇴
Future<dynamic> leaveUser(dynamic param) async {
  Uri uri = Uri.parse("${baseUrl}api/admin/user/leave");
  var res = await http.delete(uri, body: param);

  if (json.decode(res.body)["success"]) {
    await storage.delete(key: 'x_auth');
    await storage.delete(key: 'id');
  }

  return res.body;
}
