import 'dart:io';
import 'dart:ui';

import 'package:crypto_template/screen/setting/SeeAllTemplate.dart';
import 'package:crypto_template/screen/setting/themes.dart';
import 'package:crypto_template/screen/wallet/tabs/card.dart';
import 'package:flutter/material.dart';
import 'package:crypto_template/component/style.dart';
import 'package:crypto_template/Network/wallet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'dart:async';
import 'dart:convert';

String _getReference() {
  String platform;
  if (Platform.isIOS) {
    platform = 'iOS';
  } else {
    platform = 'Android';
  }

  return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
}

final _formKey = GlobalKey<FormState>();
var bitcoin = '0';
var realPrice = '0';
int amount;
var queryGotten;
class coinDeposit extends StatefulWidget {
  ///
  /// Get data bloc from
  ///
  ThemeBloc themeBloc;

  coinDeposit({Key key, this.themeBloc}) : super(key: key);

  _coinDeposit createState() => _coinDeposit(themeBloc);
}

class _coinDeposit extends State<coinDeposit> {


  @override
  void initState() {
    initPaystack();
  }
  ///
  /// Bloc for double theme
  ///
  ThemeBloc themeBloc;
  _coinDeposit(this.themeBloc);
  bool theme = true;
  String _img = "assets/image/setting/lightMode.png";

  var publicKey = '[pk_test_f68c4c8bf31e9dbe7b821d5922cc06c29505f956]';

  static const paystack_pub_key = "sk_test_644ff7e9f679a6ecfc3152e30ad453611e0e564e";
  static const paystack_backend_url = "https://infinite-peak-60063.herokuapp.com";

  Future<CheckoutResponse> initPaystack() async {
    Charge charge = Charge()
      ..amount = amount * 100
      ..reference = _getReference()
      ..accessCode = getUrl()
      ..email = 'customer@email.com';
    CheckoutResponse response = await PaystackPlugin.checkout(context,   method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,);

    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Make Payment",
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50.0,
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

                  convert(query).then((value) {
                    queryGotten = query;
                    setState(() {
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
                // getUrl(amount, bitcoin);
                  initPaystacks();
                var resp =  initPaystack();
                  print(resp);
                  print('Here');
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

  ///CheckoutResponse{message: Success, card: PaymentCard{_cvc: 408, expiryMonth: 11, expiryYear: 21, _type: Visa, _last4Digits: 4081 , _number: null}, account: null, reference: ChargedFromAndroid_1606065172022, status: true, method: CheckoutMethod.card, verify: true}
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

@override
String getUrl() {
  String urlb;
  Future<String> urlc;
  urlc = createAccessCode();
  urlc.then((value) {
   urlb = value;
  });
  return urlb;
}

var balance;

Future<void> initPaystacks() async {
  String paystackKey = "sk_test_644ff7e9f679a6ecfc3152e30ad453611e0e564e";
  var publicKey = 'pk_test_57c953b3220d4dc11412b46c30f1060c57c308b0';

  try {
    await PaystackPlugin.initialize(
        publicKey: publicKey).then((value) => {
      print(value)
    });
    // Paystack is ready for use in receiving payments
  } on PlatformException {
    // well, error, deal with it
    print('error');
  }
}
// Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MySample()),
//                   );