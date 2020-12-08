import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



Future <List<gridHome>> getListHome() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');

  var url = "https://cryptonew-api.herokuapp.com/api/mobile"; // iOS
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
    List<gridHome> _list =  List<gridHome>();
    for (var u in st) {
      //_list.add(gainers(pair: u["currency"], lastPrice: u["price"], chg: u["percentage_change"]));
      _list.add(gridHome(name: u["currency"], data: u["prices"].cast<double>().toList()));
    }
    return _list;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}


class gridHome {
  String name;
  var data;
  gridHome({this.name,this.data});
}

