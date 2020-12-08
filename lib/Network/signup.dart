import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



createAccount(email, password, firstName, lastName, phone) async {
  var url = "https://cryptonew-api.herokuapp.com/api/create/account"; // iOS
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



forgotPaasword(email) async {
  var url = "https://cryptonew-api.herokuapp.com/api/forgot/password"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
    }),
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var status = st["statusCode"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}


saveCode(code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('code', code);
  print(code);

  var status = 200;
  if (status == 200) {
    return status;
  } else {
  var notNow = 400;
    return notNow;
  }
}
//5439228



Future<String> updatePasswordNoAuth(password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String code = prefs.getString('code');
  print(code);
  var url = "https://cryptonew-api.herokuapp.com/api/new/password"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',

    },
    body: jsonEncode(<String, String>{
      'password': password,
      'code': code
    }),
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
    var status = st["message"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    print(st);
    var status = st["message"];
    return status;
  }
}



login(email, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var url = "https://cryptonew-api.herokuapp.com/api/login"; // iOS
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

  var url = "https://cryptonew-api.herokuapp.com/api/verify"; // iOS
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


Future<String>logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('id');
  print(id);

  prefs.remove("token");
  prefs.remove("email");
  prefs.remove("first_name");
  prefs.remove("last_name");
  prefs.remove("phone");

  var status = 'done';
  if (status == 'done') {
    return status;
  } else {
    var status = 'Unable to logout';
    return status;
  }
}