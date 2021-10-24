import 'dart:io';
import 'dart:ui';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:random_string/random_string.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:stripe/stripe.dart';


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
  final coin;

  coinDeposit({Key key, this.themeBloc, this.coin}) : super(key: key);

  _coinDeposit createState() => _coinDeposit(themeBloc);
}

class _coinDeposit extends State<coinDeposit> {


  String transcation = 'No transcation Yet';
  final stripe = Stripe('sk_test_51HyYgoCJuEjzdSAstUIYUrgKIA6ChIYwdn5Tc5LaIk9ctKWGvaiI589mczMA0I4yFkPViwF5bzZxmfw5FgH5hlsb00ynCnnMVR');
  final chargeId = 'ch_foobar';

  Map<String, dynamic> _data = {};
// static const platform = const MethodChannel('maugost.com/paystack_flutter');
  static const paystack_pub_key = "pk_live_9788e845e9c4098989720e1682facd83968aed3c";
  static const paystack_backend_url =
      "https://infinite-peak-60063.herokuapp.com";
  var publicKey = 'pk_live_9788e845e9c4098989720e1682facd83968aed3c';

  String paystackPublicKey = 'pk_live_9788e845e9c4098989720e1682facd83968aed3c';
  var card_type = '';

  final String txref = randomAlphaNumeric(20);
  var amount = "";
  final String currency = FlutterwaveCurrency.NGN;


  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
        context: this.context,
        encryptionKey: "FLWPUBK_TEST-SANDBOXDEMOKEY-X",
        publicKey: "FLWPUBK_TEST-SANDBOXDEMOKEY-X",
        currency: this.currency,
        amount: this.amount,
        email: "valid@email.com",
        fullName: "Valid Full Name",
        txRef: this.txref,
        isDebugMode: true,
        phoneNumber: "0123456789",
        acceptCardPayment: true,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: false,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: true,
        acceptUgandaPayment: false,
        acceptZambiaPayment: false);

    try {
      final ChargeResponse response = await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
      // print(stacktrace);
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
    initPaystacks();
  }
  ///
  /// Bloc for double theme
  ///
  ThemeBloc themeBloc;
  _coinDeposit(this.themeBloc);
  bool theme = true;
  String _img = "assets/image/setting/lightMode.png";



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
                              if (query.length < 1) return;
                              // if the length of the word is less than 2, stop executing your API call.
                              print(widget.coin);

                              convert(query, widget.coin).then((value) {
                                print(value);
                                queryGotten = query;
                                setState(() {
                                  bitcoin = value.item1.toString();
                                  realPrice = value.item2;
                                  amount = query;
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
                              '${widget.coin} :',
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
                              'USD :',
                              style: new TextStyle(
                                  color: Color(0xFF84A2AF), fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$ $realPrice',
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
                                onTap: () async {
                                  // All Stripe calls return dart objects, not generic Maps.
                                  final charge = await stripe.charge.retrieve(chargeId);
                                  print(charge.balanceTransaction);
                                },
                                child: Text("INITIATE PAYMENT",style: TextStyle(color: Colors.white),)),
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

  Future<void> initPaystacks() async {

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