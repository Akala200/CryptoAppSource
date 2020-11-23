import 'package:crypto_template/Network/wallet.dart';
import 'package:flutter/material.dart';

var queryGotten;
var bitcoin = null ?? '0';
var  realPrice;
var  amount;

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
               borderRadius: BorderRadius.all(Radius.circular(10.0))
             ),
             child: Column(
               children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 19.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text("Available (BTC)",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5),fontFamily: "Popins",fontSize: 15.5),),
               new FutureBuilder <double>(
          future: balanceNew(),
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
           Text("BTC Withdrawal Address",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7),fontFamily: "Popins",),),
            Padding(
              padding: const EdgeInsets.only(right:5.0,bottom: 35.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Paste your deliver address",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Popins",fontSize: 15.0)
                ),
              ),
            ),

             Text("Amount In Naira",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7),fontFamily: "Popins",),),
            TextField(
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
                      hintText: "#0",
                      hintStyle: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Popins",fontSize: 15.0)
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text("24H Withdrawal Limit: 2 BTC",style: TextStyle(color: Theme.of(context).hintColor,fontFamily: "Popins",fontSize: 12.0),),
                  ),
                 ],
               ),
             ),
           ),
           SizedBox(height: 20.0,),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               Text("Received Amount",style: TextStyle(color: Theme.of(context).hintColor),),
               Text("-$bitcoin BTC",style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7)),)
             ],
           ),
           SizedBox(height: 5.0,),
          Container(
            height: 50.0,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text("Withdraw",style: TextStyle(fontFamily: "Popins",fontSize: 16.0,letterSpacing: 1.5,fontWeight: FontWeight.w700),),
            ),
            ),
           SizedBox(height: 20.0,)
         ],
      ),
    );
  }
}