import 'package:crypto_template/Network/signup.dart';
import 'package:crypto_template/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:crypto_template/screen/intro/login.dart';
import 'package:crypto_template/screen/intro/signup.dart';
import 'package:crypto_template/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:crypto_template/component/style.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class verifyemail extends StatefulWidget {
  ThemeBloc themeBloc;
  verifyemail({this.themeBloc});
  @override
  _verifyemailState createState() => _verifyemailState(themeBloc);
}

class _verifyemailState extends State<verifyemail> {
  ThemeBloc _themeBloc;
  _verifyemailState(this._themeBloc);
  var code;
  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
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
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/signupHeader.png"),
                      fit: BoxFit.cover)),
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
                      EdgeInsets.only(top: mediaQuery.padding.top + 160.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 17.0, top: 7.0),
                            child: Text(
                              "Verify Account",
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  color: Colors.white,
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 3.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 90.0),
                      child: OTPTextField(
                        length: 7,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 40,
                        style: TextStyle(
                            fontSize: 13
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.underline,
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                          code = pin;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 60.0),
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          color: colorStyle.primaryColor,
                        ),
                        child: Center(
                          child: RaisedButton(
                            onPressed: () async {
                              var ressp = await verifyAccount(code);
                              if (ressp == 200){
                                Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            bottomNavBar(themeBloc: _themeBloc)));
                              } else {
                                Alert(
                                  context: context,
                                  title: "Error",
                                  desc: ressp,
                                ).show();
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
                                  "Create Account",
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new LoginNow(
                                themeBloc: _themeBloc,
                              )));
                        },
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(0.0)),
                            border: Border.all(
                              color: colorStyle.primaryColor,
                              width: 0.35,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Back to login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16.5,
                                  letterSpacing: 1.2),
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
