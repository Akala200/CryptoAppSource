import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storage = new FlutterSecureStorage();


createAccount(email, password, firstName, lastName, phone) async {
  var url = "https://coinzz.herokuapp.com/api/create/account"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
 var st = jsonDecode(response.body);
 var status = st["statusCode"];
 return status;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}



login(email, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = "https://coinzz.herokuapp.com/api/login"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );


  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var token = st["data"]["token"];
    print(token);
    var firstName = st["data"]["first_name"];

    var lastName = st["data"]["last_name"];

    var email = st["data"]["email"];

    var phone = st["data"]["phone"];
    var id = st["data"]["id"];


    await storage.write(key: "token", value: token);

    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('id', id);
    await prefs.setString('token', token);

    var status = st["statusCode"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    print(st);
    var status = st["message"];
    return status;
  }
}


verifyAccount(code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = "https://coinzz.herokuapp.com/api/verify"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'code': code,
    }),
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
    var token = st["data"]["tokenize"];
    var firstName = st["data"]["first_name"];

    var lastName = st["data"]["last_name"];

    var email = st["data"]["email"];

    var phone = st["data"]["phone"];
    var id = st["data"]["id"];


    await storage.write(key: "token", value: token);

    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('id', id);
    await prefs.setString('token', token);

    var status = st["statusCode"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}