import 'dart:async';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:sourcecodexchange/screen/wallet/tabs/coinDeposit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var balanceNewHere;
var balanceNaira;
var addressNew;

class deposit extends StatefulWidget {
  final Widget child;
  final String coinType;

  deposit({Key key, this.child, this.coinType}) : super(key: key);

  _depositState createState() => _depositState();
}

class _depositState extends State<deposit> {

  Future<double> balanceSpecified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    var url = "https://cryptonew-api.herokuapp.com/api/balance/coin?email=$email&coin_type=${widget.coinType}"; // iOS
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var st = jsonDecode(response.body);
      var balance = st["message"];
      print(balance);
      if(balance == 0){
        balance = 0.0;
        await prefs.setDouble('balance', balance);
        return balance;
      } else {
        await prefs.setDouble('balance', balance);
        return balance;
      }
    } else {
      var st = jsonDecode(response.body);
      print(st);
      var status = st["message"];
      return status;
    }
  }



  void initState() {
    super.initState();
    setState(() {
      getBalanceNew(widget.coinType);
    });
    @override
    var reee =  PaystackPlugin.initialize(
        publicKey: 'sk_live_276ea373b7eff948c77c424ea2905d965bd8e9f8');
    print(reee);
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder <double>(
        future: balanceSpecified(),
        builder: (BuildContext context, AsyncSnapshot <double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return new Text('Error: An error occurred ');
          } else
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Balance ${widget.coinType}",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5),fontFamily: "Popins",fontSize: 15.5),),
                              Text(balanceNewHere.toString(),style: TextStyle(fontFamily: "Popins"),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox( height: 20.0,),
                  FutureBuilder <String>(
                      future: address(widget.coinType),
                      builder: (BuildContext context, AsyncSnapshot <String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return new Text('Error: An error occurred ');
                        } else
                          return   Container(
                            height:125.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20.0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Text(snapshot.data,style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7),fontFamily: "Popins",),),
                                ),
                                SizedBox(height: 5.0,),
                                Container(
                                  height: 40.0,
                                  width: 150.0,
                                  color: Theme.of(context).primaryColor,
                                  child: Center(
                                    child: GestureDetector(onTap: (){
                                      WcFlutterShare.share(
                                          sharePopupTitle: 'Share',
                                          subject: 'Share Wallet Address',
                                          text: snapshot.data,
                                          mimeType: 'text/plain');
                                      // FlutterClipboard.copy(snapshot.data).then(( value ) => {
                                      // Toast.show("Copied!", context, duration: Toast.LENGTH_SHORT, backgroundColor: Colors.green, gravity:  Toast.TOP)
                                      //});
                                    }, child: Text("SHARE",style: TextStyle(color: Colors.white),)),
                                  ),
                                )
                              ],
                            ),
                          );
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  FutureBuilder <String>(
                      future: address(widget.coinType),
                      builder: (BuildContext context, AsyncSnapshot <String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return new Text('Error: ${snapshot.error}');
                        } else
                          return
                            Container(
                              height:85.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20.0,),
                                  Container(
                                    height: 40.0,
                                    width: 150.0,
                                    color: Theme.of(context).primaryColor,
                                    child: Center(
                                      child: GestureDetector( onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => coinDeposit(coin: widget.coinType,)),
                                        );
                                      }, child: Text("CARD DEPOSIT",style: TextStyle(color: Colors.white))),
                                    ),
                                  )
                                ],
                              ),
                            );
                      }),
                  SizedBox(
                    height: 20.0,
                  ),

                  Column(
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      Image.asset("assets/image/qrCode.png",height: 210.0,),
                      SizedBox(height: 25.0,),
                      Container(
                        height: 40.0,
                        width: 210.0,
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text("QR CODE COMING SOON",style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0,)
                ],
              ),
            );
        });
  }
}

@override
double getBalanceNew(coin) {
  double  _balance;
  // ignore: non_constant_identifier_names
  Future<double> StringFuture;
  StringFuture = balanceNew(coin);
  StringFuture.then((value) {
    print(value);
    balanceNewHere = value;
  });
}


