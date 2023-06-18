import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:stock_app/global/user_global.dart';
import 'package:stock_app/global/env/env.dart';

// 공통 URL 가져오기
const baseUrl = Env.baseUrl;

// 회원 주식 포트폴리오 목록 불러오기
Future<List<dynamic>> getPortfolioList(int page) async {

  Uri uri =
      Uri.parse("${baseUrl}api/stock/portfolio/list?id=$userId&page=$page");
  var res = await http.get(uri);

  print("get stock portfolio list");
  var data = json.decode(res.body);

  log("api data : ${res.body.toString()}");
  return data['portList'];
}

// 회원 주식 포트폴리오 등록
Future<dynamic> createPortfolio(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/stock/portfolio/create");
  var res = await http.post(uri, body: params);

  return res.body;
}

// 회원 주식 포트폴리오 상세보기
Future<dynamic> getPortfolioInfo(int index) async {
  print("param index : ${index}");
  Uri uri = Uri.parse("${baseUrl}api/stock/portfolio/detail?portIndex=$index");
  var res = await http.get(uri);

  return res.body;
}

// 회원 주식 포트폴리오 수정
Future<dynamic> editPortfolio(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/stock/portfolio/edit");

  var res = await http.patch(uri, body: params);

  return res.body;
}

// 회원 주식 포트폴리오 삭제
Future<dynamic> deletePortfolio(dynamic params) async {
  Uri uri = Uri.parse("${baseUrl}api/stock/portfolio/delete");

  var res = await http.delete(uri, body: params);

  return res.body;
}
