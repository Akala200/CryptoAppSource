import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



getCrypto() async {
  var url = "https://cryptonew-api.herokuapp.com/api/mobile"; // iOS
  final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(response.body);

  return dataGotten;
}





Future<dynamic> getMarket() async {
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/coin/history"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);

  return dataGotten;
}



Future<dynamic> getMarketUSD() async {
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/coin/history/usd"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);

  return dataGotten;
}


Future<dynamic> getMarketBTC() async {
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/coin/market/btc"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);

  return dataGotten;
}



Future<dynamic> getMarketUSDT() async {
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/coin/market/sudt"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);

  return dataGotten;
}


Future<dynamic> getMarketXPR() async {
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/coin/market/xrp"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);

  return dataGotten;
}

Future<dynamic> getMarketETH() async {
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/coin/market/eth"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);

  return dataGotten;
}


Future<dynamic> getBalance() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/balance/coin?email=$email"; // iOS
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);
  int status = dataGotten["statusCode"];
  if(status == 200) {
    var balanceCoin  = dataGotten["message"]["balance"].toString();
    var id  = dataGotten["message"]["id"].toString();
    await prefs.setString('balanceGotten', balanceCoin);
    await prefs.setString('walletId', id);
    print(status);
  }

  return dataGotten;
}


Future<dynamic> getAllBalance() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/wallet/all?email=$email";
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);
  int status = dataGotten["statusCode"];
  var scopeData = dataGotten["message"];
  return scopeData;
}


Future<dynamic> getAllBalanceNaira() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var res;
  var url = "https://cryptonew-api.herokuapp.com/api/balance/naira?email=$email";
  res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  var dataGotten =  jsonDecode(res.body);
  int status = dataGotten["statusCode"];
  if(status == 200) {
    var dataGotten =  jsonDecode(res.body);
    return dataGotten;

  }
}