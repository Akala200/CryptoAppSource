import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
//import 'package:paystack_sdk/paystack_sdk.dart';


class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<MySample> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = true;

  @override
  void initState() {
    super.initState();
      initPaystack();
  }
  @override

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
                        initPayment(cardNumber, cvvCode, expiryDate);
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
  try {
    //await PaystackSDK.initialize(paystackKey);
    // Paystack is ready for use in receiving payments
  } on PlatformException {
    // well, error, deal with it
    print('error');
  }
}

initPayment(cardNumber, cvvCode, expiryDate) {
  var arr = expiryDate.split('/');
  // pass card number, cvc, expiry month and year to the Card constructor function
 // var card = PaymentCard(cardNumber, cvvCode, arr[0], arr[1]);

  // create a transaction with the payer's email and amount (in kobo)
  //var transaction = PaystackTransaction("wisdom.arerosuoghene@gmail.com", 100000);

  // debit the card (using Javascript style promises)
  //transaction.chargeCard(card)
    //  .then((transactionReference) {
    // payment successful! You should send your transaction request to your server for validation
    //print(transactionReference);
  //})
    //  .catchError((e) {
    // oops, payment failed, a readable error message should be in e.message
    //print(e);
 // });
}