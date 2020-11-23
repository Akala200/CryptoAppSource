import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class assetsWallet {
   String amount,cardType,coins, lastFour,status;
  assetsWallet({this.amount,this.cardType,this.coins, this.lastFour, this.status});
}


  Future <List<assetsWallet>>  transactionHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  var url = "https://coinzz.herokuapp.com/api/history?email=$email"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var resp = st;
    List<assetsWallet> _list =  List<assetsWallet>();
    for (var u in resp) {
      //_list.add(gainers(pair: u["currency"], lastPrice: u["price"], chg: u["percentage_change"]));
          _list.add(assetsWallet(amount: u["amount"].toString(), cardType: u["cardType"], coins: u["coins"].toStringAsFixed(4),  lastFour: u["lastFour"], status: u["status"]));
    }
    return _list;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  }
}

