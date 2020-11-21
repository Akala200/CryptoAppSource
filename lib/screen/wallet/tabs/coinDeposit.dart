import 'dart:io';

import 'package:crypto_template/screen/setting/SeeAllTemplate.dart';
import 'package:crypto_template/screen/setting/themes.dart';
import 'package:crypto_template/screen/wallet/tabs/card.dart';
import 'package:flutter/material.dart';
import 'package:crypto_template/component/style.dart';
import 'package:crypto_template/Network/wallet.dart';
import 'package:url_launcher/url_launcher.dart';





final _formKey = GlobalKey<FormState>();
var bitcoin = '0';
var realPrice = '0';
int amount;
class coinDeposit extends StatefulWidget {
  ///
  /// Get data bloc from
  ///
  ThemeBloc themeBloc;

  coinDeposit({Key key, this.themeBloc}) : super(key: key);

  _coinDeposit createState() => _coinDeposit(themeBloc);
}

class _coinDeposit extends State<coinDeposit> {
  ///
  /// Bloc for double theme
  ///
  ThemeBloc themeBloc;
  _coinDeposit(this.themeBloc);
  bool theme = true;
  String _img = "assets/image/setting/lightMode.png";

  var publicKey = '[pk_test_f68c4c8bf31e9dbe7b821d5922cc06c29505f956]';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0, right: 60.0, left: 60.0),
              child: Center(
                  child: Text(
                    "Make Payment",
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontSize: 19.5,
                        fontWeight: FontWeight.w700),
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),

            ///
            /// Image header
            ///
            SizedBox(
              height: 20.0,
            ),
         Padding(
           padding:const EdgeInsets.only( right: 60.0, left: 60.0),
           child: Form(
    key: _formKey,
    child: Column(
        children: <Widget>[
        Container(
            width: 300,
            child: TextFormField(
              onChanged: (query){
                if (query.length < 4) return;
                // if the length of the word is less than 2, stop executing your API call.

                setState(() {
                  convert(query).then((value) {
                    print(value);
                    bitcoin = value.item1.toString();
                    realPrice = value.item2;
                    amount = num.parse(query);
                  });
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Enter Amount In Naira',
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
        ),

          SizedBox(
            height: 50.0,
          ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BTC :',
                  style: new TextStyle(
                      color: Color(0xFF84A2AF), fontWeight: FontWeight.bold),
                ),

                Text(
                    bitcoin,
                ),
              ],
            ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Naira :',
                style: new TextStyle(
                    color: Color(0xFF84A2AF), fontWeight: FontWeight.bold),
              ),

              Text(
                realPrice,
              ),
            ],
          ),

          SizedBox(
            height: 100.0,
          ),
          Container(
            height: 50.0,
            width: 300.0,
            color: Theme.of(context).primaryColor,
            child: Center(
              child:  GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySample()),
                  );
                },
                  child: Text("INITIATE PAYMENT",style: TextStyle(color: Theme.of(context).textSelectionColor),)),
              ),
            ),
        // Add TextFormFields and ElevatedButton here.
          //     setState(() {
            //     var newB = getAll();
              //   print(newB);
                // createAccessCode(amount, bitcoin).then((value) => {
                  // _launchURL(value)
                 //});
               //});
        ]
    )
    ),
         ),
          ],
        ),
      ),
    );
  }

  Widget listSetting(String header, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontFamily: "Sans",
                fontSize: 13.0),
          ),
          SizedBox(
            height: 9.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: "Popins",
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
          line()
        ],
      ),
    );
  }

  Widget line() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: double.infinity,
        height: 0.5,
        decoration: BoxDecoration(color: Theme.of(context).hintColor),
      ),
    );
  }

  ///
  /// Change to mode light theme
  ///
  DemoTheme _buildLightTheme() {
    return DemoTheme(
        'light',
        ThemeData(
          brightness: Brightness.light,
          accentColor: colorStyle.primaryColor,
          primaryColor: colorStyle.primaryColor,
          buttonColor: colorStyle.primaryColor,
          cardColor: colorStyle.cardColorLight,
          textSelectionColor: colorStyle.fontColorLight,
          scaffoldBackgroundColor: Color(0xFFFDFDFD),
          canvasColor: colorStyle.whiteBacground,
          dividerColor: colorStyle.iconColorLight,
          hintColor: colorStyle.fontSecondaryColorLight,
        ));
  }

  ///
  /// Change to mode dark theme
  ///
  DemoTheme _buildDarkTheme() {
    return DemoTheme(
        'dark',
        ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: colorStyle.background,
            backgroundColor: colorStyle.blackBackground,
            dividerColor: colorStyle.iconColorDark,
            accentColor: colorStyle.primaryColor,
            primaryColor: colorStyle.primaryColor,
            hintColor: colorStyle.fontSecondaryColorDark,
            buttonColor: colorStyle.primaryColor,
            canvasColor: colorStyle.grayBackground,
            cardColor: colorStyle.grayBackground,
            textSelectionColor: colorStyle.fontColorDark,
            textSelectionHandleColor: colorStyle.fontColorDarkTitle));
  }


}

_launchURL(urlz) async {
  var url = urlz;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

@override
  double getAll() {
  double balaneed;
  Future<double> listFuture;
  listFuture = getBalance();
  listFuture.then((value) {
     balance = value;
     balaneed = value;
     print(balaneed);
  });
  return balaneed == null ? 0 : balaneed;
}

var balance;