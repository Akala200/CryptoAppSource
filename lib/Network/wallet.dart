import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';


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
    var balance = st["message"];
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
    print(st);
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

Future<String>createAccessCode() async {
  // skTest -> Secret key
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
   // 'Authorization': 'Bearer $skTest'
   };
  Map data = {"amount": 10000, "email": email, "bitcoin": 0.000939393, };
  String payload = json.encode(data);                         http.Response response = await http.post(
      'https://coinzz.herokuapp.com/api/credit',
      headers: headers,
      body: payload);
  final Map dataNew = jsonDecode(response.body);
  print(dataNew);
  String accessCode = dataNew['accessCode'];
 // var databe = dataNew['data'];
  //print(databe);
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


Future<Tuple2> userDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String emailNew = prefs.getString('email');
  print(emailNew);
  var url = "https://coinzz.herokuapp.com/api/get/user?email=$emailNew"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
    var firstName = st["data"]["first_name"];
    var lastName = st["data"]["last_name"];
    return new Tuple2(firstName, lastName);
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}

Future<String> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String emailNew = prefs.getString('email');
return emailNew;
}

Future<Tuple2> getNames() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String firstName = prefs.getString('firstName');
  String lastName = prefs.getString('lastName');
  return new Tuple2(firstName, lastName);
}



Future<String> phone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String phone = prefs.getString('phone');
  return phone;
}



Future<String> updateUser(firstName, lastName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String emailNew = prefs.getString('email');
  String email = prefs.getString('email');
  String phone = prefs.getString('phone');

  print(emailNew);
  var url = "https://coinzz.herokuapp.com/api/update/user?email=$emailNew"; // iOS
  final http.Response response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
    }),
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
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
    var status = st["message"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}


Future<String> updatePassword(password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String emailNew = prefs.getString('email');


  print(emailNew);
  var url = "https://coinzz.herokuapp.com/api/update/email?email=$emailNew"; // iOS
  final http.Response response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',

    },
    body: jsonEncode(<String, String>{
      'password': password,
      'email': emailNew
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



Future<String> updateEmail(email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String emailNew = prefs.getString('email');


  var url = "https://coinzz.herokuapp.com/api/update/email?email=$emailNew"; // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',

    },
    body: jsonEncode(<String, String>{
      'email': email
    }),
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    print(st);
    var status = st["statusCode"].toString();
    return status;
  } else {
    var st = jsonDecode(response.body);
    print(st);
    var status = st["statusCode"].toString();
    return status;
  }
}



verifyEmailCode(code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var url = "https://coinzz.herokuapp.com/api/verify/new/email"; // iOS
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
    var email = st["data"]["email"];
    await prefs.setString('email', email);
    var status = st["statusCode"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}