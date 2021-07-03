import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:sourcecodexchange/component/AssetsWallet/assetsModel.dart';
import 'package:sourcecodexchange/screen/market/TabBarBody/btc.dart';
import 'package:sourcecodexchange/screen/wallet/tabs/deposit.dart';
import 'package:sourcecodexchange/screen/wallet/walletDetail.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:http/http.dart' as http;

var newBalance;
var newBalanceNaira;

class wallet extends StatefulWidget {
  //final coinType;
  final  String coinType;

  wallet({Key key, @required this.coinType }) {
    timeDilation = 1.0;
  }

  @override
  _walletState createState() => new _walletState();

}

class _walletState extends State<wallet> {
  @override
  assetsWallet item;



  @override
  void initState() {
    super.initState();
    getBalance(widget.coinType);
  //  balanceNaira();
  }
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);


    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20.0,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Wallet Details",
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
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 225.0),

            ///
            /// Create card list
            ///
            child: FutureBuilder <List<assetsWallet>>(
                future: transactionHistory(widget.coinType),
                builder: (BuildContext context, AsyncSnapshot <List<assetsWallet>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else
                    return  Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          padding: EdgeInsets.only(top: 0.0),
                          itemBuilder: (ctx, i) {
                            return card(snapshot.data[i], ctx);
                          },
                          itemCount: snapshot.data.length,
                        ));
                }),
          ),
          Column(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  ///
                  /// Create wave header
                  ///
                  new waveBody(
                    size: size, xOffset: 0, yOffset: 0, color: Colors.red, coin: widget.coinType,),
                  new Opacity(
                    opacity: 0.9,
                    child: new waveBody(
                      size: size,
                      xOffset: 60,
                      yOffset: 10,
                      coin: widget.coinType,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),

            ],
          ),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new walletDetail(coinType: widget.coinType,)));
        },
        child: Icon(Icons.account_balance_sharp),
        backgroundColor: Color(0xFF45C2DA),
      ),
    );
  }

  getBalance(coin) {
    double  _balance;
    // ignore: non_constant_identifier_names
    Future<double> StringFuture;
    StringFuture = balanceNew(coin);
    StringFuture.then((value) {
      print(value);
      setState(() {
        newBalance = value;
      });
    });
  }
}


class waveBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;
  final String coin;

  waveBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color, this.coin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _waveBodyState();
  }
}

class _waveBodyState extends State<waveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];


  getBalanceUSD() {
    double  _balance;
    // ignore: non_constant_identifier_names
    Future<double> StringFuture;
    StringFuture = getUSDBalnace();
    StringFuture.then((value) {
      print(value);
      setState(() {
        newBalanceNaira = value;
      });
    });
  }


  Future<double> getUSDBalnace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    var url = "https://cryptonew-api.herokuapp.com/api/balance/naira?email=$email&coinType=${widget.coin}"; // iOS
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var st = jsonDecode(response.body);
      var balance = st["price"];
      print(balance);
      if(balance == 0){
        balance = 0.0;
        return balance;
      } else {
        return balance;
      }
    } else {
      var st = jsonDecode(response.body);
      print(st);
      var status = st["message"];
      return status;
    }
  }


  Future<double> getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    print(email);
    var url = "https://cryptonew-api.herokuapp.com/api/balance/coin?email=$email&coin_type=${widget.coin}"; // iOS
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

  @override
  void initState() {
    getBalance();
    getBalanceUSD();

    super.initState();
    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset; i <= widget.size.width.toInt() + 2; i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                360 *
                Vector.degrees2Radians) *
                20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 185.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated,
                  colors: [Color(0xFF15EDED), Color(0xFF029CF5)])),
          child: new Container(
            margin: EdgeInsets.only(top: 75.0),
            height: 20.0,
            child: new AnimatedBuilder(
              animation: new CurvedAnimation(
                parent: animationController,
                curve: Curves.easeInOut,
              ),
              builder: (context, child) =>
              new ClipPath(
                child: widget.color == null
                    ? new Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: Colors.white.withOpacity(0.25),
                )
                    : new Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: Colors.white.withOpacity(0.9),
                ),
                clipper:
                new WaveClipper(animationController.value, animList1),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 180.0),
          height: 5.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  Theme
                      .of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.1),
                  Theme
                      .of(context)
                      .scaffoldBackgroundColor
                ],
                stops: [
                  0.0,
                  1.0
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 70.0),
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            Text(
              "Total Asseets (${widget.coin})",
              style: TextStyle(
                  fontFamily: "Popins", color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              newBalance.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "Popins",
                  fontSize: 15.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
     Text(
    'USD - ${ newBalanceNaira != null
    ? newBalanceNaira.toStringAsFixed(4)
        : '0'}',
    style: TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: "Popins",
    fontSize: 15.0,
    color: Colors.white),
    )
          ]),
        )
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(5.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}


Widget card(assetsWallet item, BuildContext ctx) {
  return  _card(Colors.lightBlueAccent, item.amount, item.coins,
      item.mode, item.type, item.status);
}






List<assetsWallet> assetsWalletList =  [];

Widget _card(Color _color, String _amount, String _coin, String _mode, String _type, String _status) {

  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
    child: Container(
      height: 120.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: _type == 'debit' ? Colors.redAccent : Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 8.0,
                        width: 8.0,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                            color: _type == 'debit' ? Colors.redAccent : Colors.green ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _amount,
                          style: TextStyle(
                              fontFamily: "Sans",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),


                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      _coin,
                      style: TextStyle(
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 45.0, right: 20.0, top: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _mode,
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),

                  Row(
                    children: <Widget>[
                      Text(
                        _type,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w800,
                            fontSize: 15.0),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        _status,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w800,
                            fontSize: 15.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

}