import 'dart:async';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:sourcecodexchange/screen/wallet/tabs/coinDeposit.dart';

var balanceNewHere;
var balanceNaira;
var addressNew;

class deposit extends StatefulWidget {
  final Widget child;

  deposit({Key key, this.child}) : super(key: key);

  _depositState createState() => _depositState();
}

class _depositState extends State<deposit> {

  void initState() {
    super.initState();
    setState(() {
      getBalanceNew();
    });
    @override
      var reee =  PaystackPlugin.initialize(
          publicKey: 'sk_live_276ea373b7eff948c77c424ea2905d965bd8e9f8');
      print(reee);
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder <double>(
        future: balanceNew(),
    builder: (BuildContext context, AsyncSnapshot <double> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return new Text('Error: An error occurred ');
      } else
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 60.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Balance (BTC)",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5),fontFamily: "Popins",fontSize: 15.5),),
                          Text(balanceNewHere.toString(),style: TextStyle(fontFamily: "Popins"),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
    FutureBuilder <String>(
    future: address(),
    builder: (BuildContext context, AsyncSnapshot <String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return new Text('Error: An error occurred ');
      } else
       return   Container(
         height:125.0,
         width: double.infinity,
         decoration: BoxDecoration(
             color: Theme.of(context).canvasColor,
             borderRadius: BorderRadius.all(Radius.circular(10.0))
         ),
         child: Column(
           children: <Widget>[
             SizedBox(height: 20.0,),
             Text(snapshot.data,style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7),fontFamily: "Popins",),),
             SizedBox(height: 15.0,),
             Container(
               height: 40.0,
               width: 150.0,
               color: Theme.of(context).primaryColor,
               child: Center(
                 child: GestureDetector(onTap: (){
                   WcFlutterShare.share(
                       sharePopupTitle: 'Share',
                       subject: 'Share Wallet Address',
                       text: snapshot.data,
                       mimeType: 'text/plain');
                  // FlutterClipboard.copy(snapshot.data).then(( value ) => {
                    // Toast.show("Copied!", context, duration: Toast.LENGTH_SHORT, backgroundColor: Colors.green, gravity:  Toast.TOP)
                   //});
                 }, child: Text("SHARE",style: TextStyle(color: Colors.white),)),
               ),
             )
           ],
         ),
       );
    }),
              SizedBox(
                height: 20.0,
              ),
              FutureBuilder <String>(
                  future: address(),
                  builder: (BuildContext context, AsyncSnapshot <String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return new Center(
                        child: new CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else
                      return
                        Container(
                height:85.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Container(
                      height: 40.0,
                      width: 150.0,
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: GestureDetector( onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => coinDeposit()),
                          );
                        }, child: Text("CARD DEPOSIT",style: TextStyle(color: Colors.white))),
                      ),
                    )
                  ],
                ),
              );
    }),
              SizedBox(
                height: 20.0,
              ),

              Column(
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  Image.asset("assets/image/qrCode.png",height: 210.0,),
                  SizedBox(height: 25.0,),
                  Container(
                    height: 40.0,
                    width: 210.0,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text("QR CODE COMING SOON",style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0,)
            ],
          ),
        );
    });
  }
}

@override
double getBalanceNew() {
  double  _balance;
  // ignore: non_constant_identifier_names
  Future<double> StringFuture;
  StringFuture = balanceNew();
  StringFuture.then((value) {
    print(value);
    balanceNewHere = value;
  });
}


