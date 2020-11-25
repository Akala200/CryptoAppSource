import 'package:sourcecodexchange/Network/signup.dart';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:sourcecodexchange/screen/intro/login.dart';
import 'package:sourcecodexchange/screen/setting/SeeAllTemplate.dart';
import 'package:sourcecodexchange/screen/setting/password.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/screen/setting/SeeAllTemplate.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/screen/AnotherTemplate/Template2/T2_Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:toast/toast.dart';
import 'package:tuple/tuple.dart';

import 'change_email.dart';
import 'names.dart';

class settings extends StatefulWidget {
  ThemeBloc themeBloc;
  settings({Key key,  this.themeBloc}) : super(key: key);

  _settings createState() => _settings(themeBloc);

}

class _settings extends State<settings> {
  ///
  /// Bloc for double theme
  ///
  ThemeBloc themeBloc;
  _settings(this.themeBloc);
  bool theme = true;
  bool _switch1 = false;
  bool _switch2 = false;
  int tapvalue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      ///
      /// Appbar
      ///
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Profile",
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

            ///
            /// This is card box for profile
            ///
            _cardProfile(),
            SizedBox(
              height: 10.0,
            ),

            _cardAnother()
          ],
        ),
      ),
    );
  }

  var _txtStyleTitle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 15.0);

  var _txtStyleDeskripsi =
  TextStyle(color: Colors.black26, fontWeight: FontWeight.w400);

  Widget _cardProfile() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)),
                      gradient: LinearGradient(
                          colors: [Color(0xFF45C2DA), Color(0xFF45C2DA)])),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 12.0,
                        ),
                      FutureBuilder <Tuple2<dynamic, dynamic>>(
                          future: getNames(),
                          builder: (BuildContext context, AsyncSnapshot <Tuple2<dynamic, dynamic>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return new Text('Error: ${snapshot.error}');
                            } else
                              return Text(
                                  snapshot.data.item1 + '  '+ snapshot.data.item2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Popins",
                                      letterSpacing: 1.5),
                                );
                          }),
                        FutureBuilder <String>(
                            future: getEmail(),
                            builder: (BuildContext context, AsyncSnapshot <String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new Center(
                                  child: new CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return new Text('Error: ${snapshot.error}');
                              } else
                                return Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Popins",
                                      letterSpacing: 1.5),
                                );
                            }),
                        SizedBox(
                          height: 7.0,
                        ),
                        FutureBuilder <String>(
                            future: phone(),
                            builder: (BuildContext context, AsyncSnapshot <String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new Center(
                                  child: new CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return new Text('Error: ${snapshot.error}');
                              } else
                                return Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Popins",
                                      letterSpacing: 1.5),
                                );
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(

                  ),
              child: Padding(
                padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "General",
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Popins"),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "Personal details",
                      style: _txtStyleTitle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "You can edit your information about your email address, phone number, or pysical address",
                      style: _txtStyleDeskripsi,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _line(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Change Personal Details", style: _txtStyleTitle),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => name()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                            child: Icon(Icons.arrow_forward, color:  Colors.black12),
                          ),
                        ),
                      ],
                    ),
                    _line(),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Change Email", style: _txtStyleTitle),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => email_update()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                            child: Icon(Icons.arrow_forward, color:  Colors.black12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
            //    Row(
              //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //  children: <Widget>[
                  //  Text("Change Phone Number", style: _txtStyleTitle),
                    //InkWell(
                      //onTap: () {
                    //  },
                  //    child: Padding(
                    //    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                      //  child: Icon(Icons.arrow_forward, color:  Colors.black12),
                     // ),
                   // ),
                //  ],
              //  ),
                    SizedBox(
                      height: 15.0,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Change Password", style: _txtStyleTitle),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => password()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                      child: Icon(Icons.arrow_forward, color:  Colors.black12),
                    ),
                  ),
                ],
              ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _line(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Night and Day", style: _txtStyleTitle),
                        Switch(
                          value: _switch2,
                          onChanged: (bool e) => _something2(e),
                          activeColor: Colors.lightBlueAccent,
                          inactiveTrackColor: Colors.black12,
                        ),
                      ],
                    ),
                    Text(
                        "Switch between night and day view",
                        style: _txtStyleDeskripsi),
                    SizedBox(
                      height: 15.0,
                    ),
                    _line(),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 25.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAnother() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Text("Another",
                  style: _txtStyleTitle.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              SizedBox(
                height: 25.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Rate this app", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Support", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Share", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              Text("Terms and policy", style: _txtStyleTitle),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () async {
                 var response = await logout();
                     // ignore: unrelated_type_equality_checks
                     if(response == 'done') {
                       Navigator.of(context)
                           .pushReplacement(PageRouteBuilder(
                           pageBuilder: (_, __, ___) => new LoginNow(
                             themeBloc: themeBloc,
                           )));
                     } else {
                       Toast.show(response, context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red,  gravity:  Toast.BOTTOM);
                     }
                },
                child: Text("Logout", style: _txtStyleTitle),
              ),
              SizedBox(
                height: 20.0,
              ),
              _line(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1.5,
      width: double.infinity,
      color: Colors.black12.withOpacity(0.03),
    );
  }

  ///
  /// void for radio button finger print
  ///
  void _something(bool e) {
    setState(() {
      if (e) {
        e = true;
        _switch1 = true;
      } else {
        e = false;
        _switch1 = false;
      }
    });
  }

  ///
  /// void for radio button notifications
  ///
  void _something2(bool e) {
    setState(() {
      if (e) {
        e = true;
        _switch2 = true;
      } else {
        e = false;
        _switch2 = false;
      }
      if (theme == true) {
        setState(() {
          theme = false;
        });
        themeBloc.selectedTheme.add(_buildLightTheme());
      } else {
        themeBloc.selectedTheme.add(_buildDarkTheme());
        setState(() {
          theme = true;
        });
      }
    });
  }


  ///
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


