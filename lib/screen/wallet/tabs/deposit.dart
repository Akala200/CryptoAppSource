import 'dart:async';
import 'package:crypto_template/Network/wallet.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:share/share.dart';

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
        return new Text('Error: ${snapshot.error}');
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
        return new Text('Error: ${snapshot.error}');
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
                 child: RaisedButton(onPressed: (){
                   FlutterClipboard.copy(snapshot.data).then(( value ) => {
                     Toast.show("Copied!", context, duration: Toast.LENGTH_SHORT, backgroundColor: Colors.green, gravity:  Toast.TOP)
                   });
                 }, child: Text("COPY ADDRESS",style: TextStyle(color: Theme.of(context).textSelectionColor),)),
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
                        child: RaisedButton( onPressed: (){
                          final RenderBox box = context.findRenderObject();
                          Share.share(snapshot.data,
                              subject: 'Share Wallet Address',
                              sharePositionOrigin:
                              box.localToGlobal(Offset.zero) &
                              box.size);
                        }, child: Text("Share Address",style: TextStyle(color: Theme.of(context).textSelectionColor),)),
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
                    width: 150.0,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text("SAVE IMAGE",style: TextStyle(color: Theme.of(context).textSelectionColor),),
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


