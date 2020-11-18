import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storage = new FlutterSecureStorage();


Future<double> balanceNew() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  var url = "https://coinzz.herokuapp.com/api/balance/coin?email=$email"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var balance = st["message"]["balance"];
    await prefs.setDouble('balance', balance);
    return balance;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}


Future<double> balanceNaira() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  var url = "https://coinzz.herokuapp.com/api/balance/naira?email=$email"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
    var balance = st["price"];
    await prefs.setDouble('balance', balance);
    return balance;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}



Future<String> address() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  var url = "https://coinzz.herokuapp.com/api/user/address?email=$email"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
    var address = st["message"];
    await prefs.setString('address', address);
    return address;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}

