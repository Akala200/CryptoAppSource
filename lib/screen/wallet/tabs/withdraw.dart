import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'dart:async';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../walletDetail.dart';

var queryGotten;
var bitcoin = null ?? '0';
var realPrice;
var amount;
var activity = '';
var address;
var email;
var bitcoinB;
var flatAmount;
var fee;

class withDraw extends StatefulWidget {
  final Widget child;

  withDraw({Key key, this.child}) : super(key: key);

  _withDrawState createState() => _withDrawState();
}

class _withDrawState extends State<withDraw> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Available (BTC)",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "Popins",
                            fontSize: 15.5),
                      ),
                      new FutureBuilder<double>(
                          future: balanceNew(),
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return new Text('Error: ${snapshot.error}');
                            } else
                              return Text(
                                snapshot.data.toString(),
                                style: TextStyle(fontFamily: "Popins"),
                              );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 355.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 27.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, bottom: 35.0),
                    child: DropDown(
                      items: ["Withdraw", "Transfer"],
                      hint: Text("Select Transaction Method"),
                      onChanged: (value) {
                        setState(() {
                          activity = value;
                        });
                        print(activity);
                      },
                    ),
                  ),
                  if (activity == 'Transfer')
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, bottom: 35.0),
                      child: TextField(
                        onChanged: (value){
                          address = value;
                          print(address);
                        },
                        decoration: InputDecoration(
                            hintText: "Paste your deliver address",
                            labelText: 'Enter Or Paste Wallet Address',
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: "Popins",
                                fontSize: 15.0)),
                      ),
                    ),
                  TextField(
                    onChanged: (query) {
                      if (query.length < 4) return;
                      // if the length of the word is less than 2, stop executing your API call.

                      convert(query).then((value) {
                        queryGotten = query;
                        setState(() {
                          bitcoin = value.item1.toString();
                          realPrice = value.item2;
                          flatAmount = value.item1;
                          bitcoinB = value.item1;
                          amount = num.parse(query);
                          feeAmount(amount);
                        });
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "#0",
                        labelText: 'Amount In Naira',
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontFamily: "Popins",
                            fontSize: 15.0)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "24H Withdrawal Limit: 2 BTC",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "Popins",
                          fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Fixed Fee",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              Text(
                "800 Naira",
                style: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7)),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Variable Fee",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              Text(
                "0.015% of Naira Amount",
                style: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7)),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Received Amount",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              Text(
                "$bitcoin BTC",
                style: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7)),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          if (activity == 'Transfer')
            Container(
              height: 50.0,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                 var rspp = transfer(amount.toString(), flatAmount.toString(), bitcoinB.toString(), fee.toString(), address );
                 // ignore: unrelated_type_equality_checks
                 if (rspp == 200) {
                   Navigator.of(context).push(PageRouteBuilder(
                       pageBuilder: (_, __, ___) => new walletDetail()));
                 }
                  },
                  child: Text(
                    "Transfer",
                    style: TextStyle(
                        fontFamily: "Popins",
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          if (activity == 'Withdraw')
            Container(
              height: 50.0,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: GestureDetector(
                child: Text(
                  "Withdraw",
                  style: TextStyle(
                      fontFamily: "Popins",
                      fontSize: 16.0,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}





double feeAmount(amountc) {
  double coin;
  var feeAmount = amountc - 0.015 / 100 * amountc ;
 var calculatedFee = amountc - feeAmount;
  Future<double> addressC;
  addressC = getCoin(feeAmount);
  addressC.then((value) {
    fee = value;
    print(fee);

  });
  return coin;
}
