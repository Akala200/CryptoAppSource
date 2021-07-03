import 'package:sourcecodexchange/screen/wallet/tabs/deposit.dart';
import 'package:sourcecodexchange/screen/wallet/tabs/withdraw.dart';
import 'package:sourcecodexchange/screen/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class WalletMain extends StatefulWidget {
  final Widget child;

  WalletMain({Key key, this.child}) : super(key: key);

  _walletMainState createState() => _walletMainState();
}

class _walletMainState extends State<WalletMain>
    with SingleTickerProviderStateMixin {


  var btcBalance;
  var ethBalance;
  var dogeBalance;
  var bCashBalance;
  var litBalance;
  var zecBalance;

  getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    var url = "https://cryptonew-api.herokuapp.com/api/get/wallet?email=$email"; // iOS
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var st = jsonDecode(response.body);
      print(st);
      setState(() {
        btcBalance = st["balance"];
        ethBalance = st["eth_balance"];
        dogeBalance = st["dodge_balance"];
        bCashBalance = st["bcash_balance"];
        litBalance = st["lit_balance"];
        zecBalance = st["zec_balance"];
      });

    } else {
      var st = jsonDecode(response.body);
      print(st);
      var status = st["message"];
      return status;
    }
  }


  @override
  void initState() {
    super.initState();
    getWallet();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text(
            "Wallets",
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontFamily: "Gotik",
                fontWeight: FontWeight.w600,
                fontSize: 18.5),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: 50.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new wallet(coinType: 'BTC',)));
                    },
                    child: Container(
                      height: 135,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        color: Colors.lightBlueAccent.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Wallet Type :'),
                                    Text('BTC')
                                  ],
                                ),
                                SizedBox(height: 30.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Balance :'),
                                    Text(btcBalance != null ? btcBalance.toString(): '0')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0,),

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new wallet(coinType: 'ETH',)));
                    },
                    child: Container(
                      height: 135,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        color: Colors.lightBlueAccent.withOpacity(0.5),
                        child:Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Wallet Type :'),
                                    Text('ETH')
                                  ],
                                ),
                                SizedBox(height: 30.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Balance :'),
                                    Text(ethBalance != null ? ethBalance.toString(): '0')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new wallet(coinType: 'BCH',)));
                    },
                    child: Container(
                      height: 135,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        color: Colors.lightBlueAccent.withOpacity(0.5),
                        child:Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Wallet Type :'),
                                    Text('BCH')
                                  ],
                                ),
                                SizedBox(height: 30.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Balance :'),
                                    Text(bCashBalance != null ? bCashBalance.toString(): '0')
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
    );
  }
}