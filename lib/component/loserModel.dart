import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class losers {
  String pair,lastPrice, chg;
  losers({this.pair, this.lastPrice, this.chg});
}


Future <List<losers>> getList2() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');

  var url = "https://cryptonew-apis.herokuapp.com/api/coin/history/usd"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'authorization': '$token',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    List<losers> _list =  List<losers>();
    for (var u in st) {
      //_list.add(gainers(pair: u["currency"], lastPrice: u["price"], chg: u["percentage_change"]));
      _list.add(losers(pair: u["currency"], lastPrice: u["price"], chg: u["percentage_change"]));
    }
    return _list;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}

