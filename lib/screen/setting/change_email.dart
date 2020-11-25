import 'package:sourcecodexchange/Network/signup.dart';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sourcecodexchange/screen/setting/verify_email.dart';
import 'package:tuple/tuple.dart';
import 'package:toast/toast.dart';

var email;
Future<Tuple2> _future;
// ignore: must_be_immutable, camel_case_types
class email_update extends StatefulWidget {
  ThemeBloc themeBloc;
  email_update({this.themeBloc});
  @override
  _email_update createState() => _email_update(themeBloc);
}

class _email_update extends State<email_update> {
  var myControllerEmail = TextEditingController();


  /// To set duration initState auto start if FlashSale Layout open
  @override
  void initState() {
    getEmailNow();
    super.initState();
  }
  ThemeBloc _themeBloc;
  _email_update(this._themeBloc);
  var code;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myControllerEmail.dispose();
    super.dispose();
  }

  @override
  String getEmailNow() {
    String _listProducts;
    Future<String> listFuture;
    listFuture = getEmail();
    listFuture.then((value) {
      myControllerEmail.text = value;
    });
  }

  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Change Email",
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: colorStyle.background),
        child: Stack(
          children: <Widget>[
            ///
            /// Set image in top
            ///
            Container(
              height: 149.0,
              width: double.infinity,
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.only(top: mediaQuery.padding.top + 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 17.0, top: 7.0),
                            child: Text(
                              "Change  Details",
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 80.0, right: 80.0, top: 60.0),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (text) {
                                setState(() {
                                  email = text;
                                });
                              },
                              style: new TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: myControllerEmail,
                              obscureText: false,
                              autofocus: false,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 80.0, right: 80.0, top: 60.0),
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          color: colorStyle.primaryColor,
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              Loader.show(context,
                                  progressIndicator: CircularProgressIndicator(
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  themeData: Theme.of(context).copyWith(
                                      accentColor: Colors.blueAccent));
                              var ressp = await updateEmail(email);
                              if (ressp == '200') {
                                Loader.hide();
                                Toast.show("User Details Updated successfully", context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.green,  gravity:  Toast.BOTTOM);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => verifyemailLoggedIn()),
                                );
                              } else {
                                Loader.hide();
                                Toast.show(ressp, context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red,  gravity:  Toast.BOTTOM);
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(0.0)),
                                color: colorStyle.primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  "Update Details",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,
                                      letterSpacing: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFeild({
    String hint,
    TextEditingController controller,
    TextInputType keyboardType,
    bool obscure,
    String icon,
    TextAlign textAlign,
    Widget widgetIcon,
  }) {
    return Column(
      children: <Widget>[
        Container(
          height: 55.5,
          decoration: BoxDecoration(
            color: Colors.black26,
//              color: Color(0xFF282E41),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
              color: colorStyle.primaryColor,
              width: 0.15,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
            child: Theme(
              data: ThemeData(hintColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextField(
                  style: new TextStyle(color: Colors.white),
                  textAlign: textAlign,
                  obscureText: obscure,
                  controller: controller,
                  keyboardType: keyboardType,
                  autocorrect: false,
                  autofocus: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: widgetIcon,
                      ),
                      contentPadding: EdgeInsets.all(0.0),
                      filled: true,
                      fillColor: Colors.transparent,
                      labelText: hint,
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white70,
                      )),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


