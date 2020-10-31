import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';



createAccount(email, password, firstName, lastName, hintz, phone) async {
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
      'currency': hintz,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
  } else {
    throw Exception('Failed to create album.');
  }
}