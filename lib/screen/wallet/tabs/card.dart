import 'dart:io';

import 'package:crypto_template/screen/wallet/tabs/coinDeposit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
//import 'package:paystack_sdk/paystack_sdk.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';


class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

String _getReference() {
  String platform;
  if (Platform.isIOS) {
    platform = 'iOS';
  } else {
    platform = 'Android';
  }

  return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
}

class MySampleState extends State<MySample> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = true;

  String _message = '';
  bool _paymentReady = false;


  @override
  void initState() {
  initPaystack();
  }

  Future<CheckoutResponse> initPaystack() async {
    Charge charge = Charge()
      ..amount = 10000
      ..reference = _getReference()
      ..accessCode = getUrl()
      ..email = 'customer@email.com';
    CheckoutResponse response = await PaystackPlugin.checkout(context,   method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: CreditCardForm(
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ),
              ),

              Container(
                height: 50.0,
                width: 300.0,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child:  GestureDetector(
                      onTap: () {

                        initPaystack();
                      },
                      child: Text("Make PAYMENT",style: TextStyle(color: Theme.of(context).textSelectionColor),)),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      print(expiryDate);
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}


Future<void> initPaystack() async {
  String paystackKey = "sk_test_644ff7e9f679a6ecfc3152e30ad453611e0e564e";
  var publicKey = 'pk_live_149127b35639db9211193e2dc2296e769b30c494';

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
