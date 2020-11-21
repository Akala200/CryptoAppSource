import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

final storage = new FlutterSecureStorage();

var skTest = "sk_test_644ff7e9f679a6ecfc3152e30ad453611e0e564e";

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

Future<Tuple2> convert(query) async {
  var url = "https://coinzz.herokuapp.com/api/convert?amount=$query"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var bitcoin = st["price"];
    var price = st["amountAfterFee"].toString();
   return new Tuple2(bitcoin, price);
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}

Future<String> realAmount(query) async {
  var url = "https://coinzz.herokuapp.com/api/convert?amount=$query"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var price = st["amountAfterFee"].toString();
    return price;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}

Future<String>createAccessCode(amount, bitcoin) async {
  // skTest -> Secret key
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
   // 'Authorization': 'Bearer $skTest'
   };
  Map data = {"amount": amount, "email": email, "bitcoin": bitcoin, };
  String payload = json.encode(data);                         http.Response response = await http.post(
      'https://coinzz.herokuapp.com/api/credit',
      headers: headers,
      body: payload);
  final Map dataNew = jsonDecode(response.body);
  print(dataNew);
  String accessCode = dataNew['authorization_url'];
  var databe = dataNew['data'];
  print(databe);
  return accessCode;
}


void _verifyOnServer(String reference) async {
  try {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'};
    http.Response response = await http.get(
        'https://api.paystack.co/transaction/verify/' + reference,
        headers: headers);
    final Map body = json.decode(response.body);
    if (body['data']['status'] == 'success') {
      //do something with the response. show success}
    } else { //show error prompt
      print('here');
    }
  }
    catch (e) {
    print(e);
  }
}


Future<double> getBalance() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var balance = prefs.getDouble('balance');
  return balance;
}