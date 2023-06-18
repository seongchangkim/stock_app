import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_app/global/env/env.dart';

// twelve api key 가져오기
const authKey = Env.authKey;

// 미국 주식 및 ETF 검색 기능
Future<List> searchAmericaStockList(String keyWord) async {
  Uri uri = Uri.parse(
      'https://api.twelvedata.com/symbol_search?outputsize=30&country=United States&symbol=$keyWord');
  var headers = {'Authorization': 'apikey $authKey'};
  var res = await http.get(uri, headers: headers);

  var data = json.decode(res.body)['data'];

  return data;
}
