
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:sourcecodexchange/component/AssetsWallet/assetsModel.dart';
import 'package:sourcecodexchange/screen/market/TabBarBody/btc.dart';
import 'package:sourcecodexchange/screen/wallet/walletDetail.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/Network/wallet.dart';

var newBalance;
var newBalanceNaira;

class wallet extends StatefulWidget {
  @override
  _walletState createState() => new _walletState();

  ///
  /// time for wave header wallet
  ///
  wallet() {
    timeDilation = 1.0;
  }
}

class _walletState extends State<wallet> {
  @override
  assetsWallet item;

  @override
  void initState() {
    getNew();
    super.initState();
    getBalance();
     getNew();
    getBalanceNaira();
    setState(() {
      getBalance();
    });
    setState(() {
      getNew();
    });
    setState(() {
      getBalanceNaira();
    });
  }
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);


    return  Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 225.0),

            ///
            /// Create card list
            ///
            child: FutureBuilder <List<assetsWallet>>(
    future: transactionHistory(),
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
          itemCount: assetsWalletList.length,
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
                      size: size, xOffset: 0, yOffset: 0, color: Colors.red),
                  new Opacity(
                    opacity: 0.9,
                    child: new waveBody(
                      size: size,
                      xOffset: 60,
                      yOffset: 10,
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
              pageBuilder: (_, __, ___) => new walletDetail()));
        },
        child: Icon(Icons.account_balance_sharp),
        backgroundColor: Color(0xFF45C2DA),
      ),
    );
  }
}

class waveBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  waveBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _waveBodyState();
  }
}

class _waveBodyState extends State<waveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();
    getBalance();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
      i <= widget.size.width.toInt() + 2;
      i++) {
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
    return new FutureBuilder <int>(
        future: balanceNew(),
        builder: (BuildContext context, AsyncSnapshot <int> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else
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
                      builder: (context, child) => new ClipPath(
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
                          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                          Theme.of(context).scaffoldBackgroundColor
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
                      "Total Asseets (BTC)",
                      style: TextStyle(fontFamily: "Popins", color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      newBalance.toStringAsFixed(6),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "Popins",
                          fontSize: 15.0,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
   FutureBuilder <double>(
    future: balanceNaira(),
    builder: (BuildContext context, AsyncSnapshot <double> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return new Text('Error: ${snapshot.error}');
      } else
       return   Text(
          'NGN-' + snapshot.data.toString(),
          style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: "Popins",
          fontSize: 15.0,
          color: Colors.white),
          );
    }),
                  ]),
                )
              ],
            );
        });
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
              item.cardType + '***' + item.lastFour);
}




@override
double getBalance() {
  double  _balance;
  // ignore: non_constant_identifier_names
  Future<int> StringFuture;
  StringFuture = balanceNew();
  StringFuture.then((value) {
    newBalance = value;
  });
}

@override
double getBalanceNaira() {
  double  _balance;
  // ignore: non_constant_identifier_names
  Future<double> StringFuture;
  StringFuture = balanceNaira();
  StringFuture.then((value) {
    newBalanceNaira = value;
  });
}

@override
Future<List<assetsWallet>> getNew() {
  List<assetsWallet> _listProducts;
  Future<List<assetsWallet>> listFuture;
  listFuture = transactionHistory();
  listFuture.then((value) {
    _listProducts = value;
    assetsWalletList = _listProducts;
  });
}



List<assetsWallet> assetsWalletList =  [];

Widget _card(Color _color, String _title, String _time, String _value) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
    child: Container(
      height: 120.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Color(0xFF363940),
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
                            color: Colors.white70 ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          _title,
                          style: TextStyle(
                              fontFamily: "Sans",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.open_in_new,
                    size: 17.0,
                    color: Colors.white24,
                  )
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
                    _time,
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w100,
                        color: Colors.white54),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        _value,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w800,
                            fontSize: 19.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}