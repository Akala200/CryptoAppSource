import 'dart:io';
import 'dart:ui';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:sourcecodexchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:random_string/random_string.dart';
import 'package:flutterwave/flutterwave.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

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
class SetUp extends StatefulWidget {
  ///
  /// Get data bloc from
  ///
  ThemeBloc themeBloc;
  final coin;

  SetUp({Key key, this.themeBloc, this.coin}) : super(key: key);

  _SetUp createState() => _SetUp(themeBloc);
}

class _SetUp extends State<SetUp> {


  String transcation = 'No transcation Yet';
  Map<String, dynamic> _data = {};
// static const platform = const MethodChannel('maugost.com/paystack_flutter');
  static const paystack_pub_key = "pk_live_9788e845e9c4098989720e1682facd83968aed3c";
  static const paystack_backend_url =
      "https://infinite-peak-60063.herokuapp.com";
  var publicKey = 'pk_live_9788e845e9c4098989720e1682facd83968aed3c';
  var dropdownValue = '';
  var banks = [];
  var accountNumber;
  var bvn;

  String paystackPublicKey = 'pk_live_9788e845e9c4098989720e1682facd83968aed3c';
  var card_type = '';

  final String txref = randomAlphaNumeric(20);
  var amount = "";
  final String currency = FlutterwaveCurrency.NGN;


   getBanks() async {
    var url = "https://cryptonew-api.herokuapp.com/api/get/bank"; // iOS
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
       banks = st;
     });
    } else {
      var st = jsonDecode(response.body);
     setState(() {
       banks = ["No banks added"];
     });
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data.currency == this.currency &&
        response.data.amount == this.amount &&
        response.data.txRef == this.txref;
  }

  @override
  void initState() {
    getBanks();
  }
  ///
  /// Bloc for double theme
  ///
  ///
  ThemeBloc themeBloc;
  _SetUp(this.themeBloc);
  bool theme = true;
  String _img = "assets/image/setting/lightMode.png";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text(
            "Complete Account Setup",
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontFamily: "Gotik",
                fontWeight: FontWeight.w600,
                fontSize: 20.5),
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 160.0,
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
                              bvn = query;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter Your BVN Number',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 40.0,
                        ),

                        Container(
                          width: 300,
                          child: TextFormField(
                            onChanged: (query){
                              accountNumber = query;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter Your Account Number',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 40.0,
                        ),



                        DropDownFormField(
                          titleText: 'Selected Bank',
                          hintText: 'Select Your Bank',
                          value: dropdownValue,
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          },
                          dataSource: banks,
                          textField: 'name',
                          valueField: 'code',
                        ),

                        SizedBox(
                          height: 40.0,
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
                                onTap: () async{
                                    // skTest -> Secret key

                                  Loader.show(context,
                                      progressIndicator: CircularProgressIndicator(
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                      themeData: Theme.of(context)
                                          .copyWith(accentColor: Colors.blueAccent));

                                    Map<String, String> headers = {
                                      'Content-Type': 'application/json',
                                      'Accept': 'application/json',
                                      // 'Authorization': 'Bearer $skTest'
                                    };
                                    Map data = {"account_number": accountNumber, "bank_code": dropdownValue, "bvn": bvn };
                                    String payload = json.encode(data);
                                    http.Response response = await http.post(
                                        'https://cryptonew-api.herokuapp.com/api/complete/account',
                                        headers: headers,
                                        body: payload);
                                    if (response.statusCode == 200) {
                                      Loader.hide();
                                      Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  bottomNavBar(themeBloc: themeBloc)));
                                    } else {
                                      var st = jsonDecode(response.body);
                                      var ressp = st["message"];
                                      Loader.hide();
                                      Toast.show(ressp, context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red,  gravity:  Toast.BOTTOM);
                                    }
                                },
                                child: Text("Complete Account Setup",style: TextStyle(color: Colors.white),)),
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


// Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MySample()),
//                   );