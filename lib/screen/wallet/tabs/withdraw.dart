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
var  realPrice;
var  amount;
var accountAccount;
var accountBank;
var amountB4Fee;
var  coinType;
var address;

var activity = '';
class withDraw extends StatefulWidget {
  final Widget child;
  final String coinType;


  withDraw({Key key, this.child, this.coinType}) : super(key: key);

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
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 19.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Available ${widget.coinType}",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5),fontFamily: "Popins",fontSize: 15.5),),
                      new FutureBuilder <double>(
                          future: balanceNew(widget.coinType),
                          builder: (BuildContext context, AsyncSnapshot <double> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return new Text('Error: ${snapshot.error}');
                            } else
                              return  Text(snapshot.data.toString(),style: TextStyle(fontFamily: "Popins"),);
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
            height:355.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:18.0,right: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 27.0,),
                  Padding(
                    padding: const EdgeInsets.only(right:5.0,bottom: 35.0),
                    child: DropDown(
                      items: ["Withdraw", "Transfer"],
                      hint: Text("Select Transaction Method"),
                      onChanged: (value){
                        setState(() {
                          activity = value;
                        });
                        print(activity);
                      },
                    ),
                  ),
                  if (activity == 'Transfer')

                    Padding(
                      padding: const EdgeInsets.only(right:5.0,bottom: 35.0),
                      child: TextField(
                        onChanged: (val){
                          address = val;
                        },
                        decoration: InputDecoration(
                            hintText: "Paste the recipient address",
                            labelText: 'Enter Or Paste Wallet Address',
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Popins",fontSize: 15.0)
                        ),
                      ),
                    ),

                  TextField(
                    onChanged: (query){
                      if (query.length < 4) return;
                      // if the length of the word is less than 2, stop executing your API call.

                      convert(query, widget.coinType).then((value) {
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
                        hintText: "0",
                        labelText: 'Amount In Naira',
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Popins",fontSize: 15.0)
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  if (activity == 'Withdraw')
                    TextField(
                      onChanged: (query){
                        setState(() {
                          accountAccount = query;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Enter Account Number",
                          labelText: 'Account number',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Poppins",fontSize: 15.0)
                      ),
                    ),
                  if (activity == 'Withdraw')
                    TextField(
                      onChanged: (query){
                        setState(() {
                          accountBank = query;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Enter Account Bank",
                          labelText: 'Account Bank',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Poppins",fontSize: 15.0)
                      ),
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text("48H Withdrawal timeline",style: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Popins",fontSize: 12.0),),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Amount ${widget.coinType}",style: TextStyle(color: Theme.of(context).hintColor),),
              Text("$bitcoin",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7)),)
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Amount NGN",style: TextStyle(color: Theme.of(context).hintColor),),
              Text("$realPrice",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7)),)
            ],
          ),
          SizedBox(height: 15.0,),
          if (activity == 'Withdraw')
            Container(
              height: 50.0,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: GestureDetector(
                onTap: () async{
                  var response = await withdraw();
                  // ignore: unrelated_type_equality_checks
                  print(response);
                  if(response == "Request initiated"){
                    Toast.show('Withdrawal Request Initiated Successfully', context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.green,  gravity:  Toast.BOTTOM);
                    Navigator.pop(context);
                  } else {
                    Toast.show('Insufficient Funds Or Server Error', context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red,  gravity:  Toast.BOTTOM);
                  }
                },
                child: Center(
                  child: Text(activity,style: TextStyle(fontFamily: "Popins",fontSize: 16.0,letterSpacing: 1.5,fontWeight: FontWeight.w700),),
                ),
              ),
            ),

          if (activity == 'Transfer')
            Container(
              height: 50.0,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: GestureDetector(
                onTap: () async{
                  var response = await transferInitiation();
                  // ignore: unrelated_type_equality_checks
                  print(response);
                  if(response == "Request initiated"){
                    Toast.show('Withdrawal Request Initiated Successfully', context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.green,  gravity:  Toast.BOTTOM);
                    Navigator.pop(context);
                  } else {
                    Toast.show('Insufficient Funds Or Server Error', context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red,  gravity:  Toast.BOTTOM);
                  }
                },
                child: Center(
                  child: Text(activity,style: TextStyle(fontFamily: "Popins",fontSize: 16.0,letterSpacing: 1.5,fontWeight: FontWeight.w700),),
                ),
              ),
            ),
          SizedBox(height: 20.0,)
        ],
      ),
    );
  }
  String transferInitiation() {
    String valued;     // ignore: non_constant_identifier_names
    Future<String> stringFuture;
    coinType = widget.coinType;
    stringFuture = transfer(realPrice, bitcoin, coinType, address);
    stringFuture.then((value) {
      print(value);
      valued  = value;
    });
    return valued;

  }


  String withdraw() {
    String valued;     // ignore: non_constant_identifier_names
    Future<String> stringFuture;
    stringFuture = createWithdraw(amount, bitcoin, accountAccount, accountBank);
    stringFuture.then((value) {
      print(value);
      valued  = value;
    });
    return valued;

  }
}