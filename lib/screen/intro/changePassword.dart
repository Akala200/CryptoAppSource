import 'package:sourcecodexchange/Network/signup.dart';
import 'package:sourcecodexchange/Network/wallet.dart';
import 'package:sourcecodexchange/screen/AnotherTemplate/Template4/setting_layout/T4_setting_account.dart';
import 'package:sourcecodexchange/screen/AnotherTemplate/Template5/T5_profile.dart';
import 'package:sourcecodexchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:sourcecodexchange/screen/intro/login.dart';
import 'package:sourcecodexchange/screen/intro/signup.dart';
import 'package:sourcecodexchange/screen/setting/setting.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tuple/tuple.dart';
import 'package:toast/toast.dart';

var password1;
var password2;
// ignore: must_be_immutable, camel_case_types
class changePassword extends StatefulWidget {
  ThemeBloc themeBloc;
  changePassword({this.themeBloc});
  @override
  _changePassword createState() => _changePassword(themeBloc);
}

class _changePassword extends State<changePassword> {
  var myControllerPassword1= TextEditingController();
  var myControllerPassword2 = TextEditingController();


  /// To set duration initState auto start if FlashSale Layout open
  ThemeBloc _themeBloc;
  _changePassword(this._themeBloc);
  var code;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myControllerPassword1.dispose();
    myControllerPassword2.dispose();
    super.dispose();
  }

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
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child:  Form(
                  key: _form,
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
                                "Create New Password",
                                style: TextStyle(
                                    fontFamily: "Sans",
                                    color: Colors.white,
                                    fontSize: 18.0,
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
                              TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    password1 = text;
                                  });
                                },
                                style: new TextStyle(color: Colors.white),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  labelText: 'Enter New Password',
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                controller: myControllerPassword1,
                                obscureText: true,
                                autofocus: false,
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    password2 = text;
                                  });
                                },
                                style: new TextStyle(color: Colors.white),
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                controller: myControllerPassword2,
                                obscureText: true,
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
                                _form.currentState.validate();
                                Loader.show(context,
                                    progressIndicator: CircularProgressIndicator(
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    themeData: Theme.of(context).copyWith(
                                        accentColor: Colors.blueAccent));
                                var ressp = await updatePasswordNoAuth(password1);
                                if (ressp == 'Success') {
                                  Loader.hide();
                                  Navigator.of(context)
                                      .pushReplacement(PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => new LoginNow(
                                        themeBloc: _themeBloc,
                                      )));
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
                                    "Change Password",
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


