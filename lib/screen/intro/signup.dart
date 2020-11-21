import 'package:crypto_template/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:crypto_template/screen/home/home.dart';
import 'package:crypto_template/screen/intro/login.dart';
import 'package:crypto_template/screen/intro/verify.dart';
import 'package:crypto_template/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:crypto_template/component/style.dart';
import 'package:crypto_template/Network/signup.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:loading_overlay/loading_overlay.dart';



class signUp extends StatefulWidget {
  ThemeBloc themeBloc;
  signUp({this.themeBloc});
  @override
  _signUpState createState() => _signUpState(themeBloc);
}

class _signUpState extends State<signUp> {
  ThemeBloc _themeBloc;
  _signUpState(this._themeBloc);

  var firstName;
  var lastName;
  var email;
  var phone;
  var hintz;
  var password;


  @override
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  //final dropdownValue;
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    String dropdownValue;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,

        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(color: colorStyle.background),
        child: Stack(
          children: <Widget>[
            ///
            /// Set image in top
            ///
            Container(
              height: 129.0,
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
                    /// Animation text marketplace to choose Login with Hero Animation (Click to open code)

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 230.0),
                      child: _buildTextFeild(
                          widgetIcon: Icon(
                            Icons.people,
                            color: colorStyle.primaryColor,
                            size: 20,
                          ),
                          controller: _firstNameController,
                          hint: 'First Name',
                          obscure: false,
                          textCapture:  (String value) {
                            setState(() {
                              firstName = value;
                            });
                          },
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: _buildTextFeild(
                          widgetIcon: Icon(
                            Icons.people,
                            color: colorStyle.primaryColor,
                            size: 20,
                          ),
                          controller: _lastNameController,
                          textCapture:  (String value) {
                            setState(() {
                              lastName = value;
                            });
                          },
                          hint: 'Last Name',
                          obscure: false,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: _buildTextFeild(
                          widgetIcon: Icon(
                            Icons.email,
                            color: colorStyle.primaryColor,
                            size: 20,
                          ),
                          controller: _emailController,
                          hint: 'Email',
                          obscure: false,
                          textCapture:  (String value) {
                            setState(() {
                              email = value;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: _buildTextFeild(
                          widgetIcon: Icon(
                            Icons.phone,
                            size: 20,
                            color: colorStyle.primaryColor,
                          ),
                          controller: _phoneController,
                          hint: 'Phone Number',
                          obscure: false,
                          textCapture:  (String value) {
                            setState(() {
                              phone = value;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.start),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: DropdownButtonFormField<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          hint: Text('Phone'),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.white),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>[ 'Naira', 'Dollar', 'Pounds']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: _buildTextFeild(
                          widgetIcon: Icon(
                            Icons.vpn_key,
                            size: 20,
                            color: colorStyle.primaryColor,
                          ),
                          controller: _passwordController,
                          hint: 'Password',
                          obscure: true,
                          textCapture:  (String value) {
                            setState(() {
                              password = value;
                            });
                          },
                          keyboardType: TextInputType.visiblePassword,
                          textAlign: TextAlign.start),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 40.0),
                      child: GestureDetector(
                        onTap: () async {
                          Loader.show(context,progressIndicator: CircularProgressIndicator(backgroundColor: Colors.blueGrey,),themeData: Theme.of(context).copyWith(accentColor: Colors.blueAccent));
                          var ressp = await createAccount(email, password, firstName, lastName, phone);
                        if (ressp == 201){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => verifyemail()),
                          );
                        } else {
                          Loader.hide();
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
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17.5,
                                  letterSpacing: 1.9),
                            ),
                          ),
                        ),
                      ),
                    ),
//                  Padding(
//                    padding: const EdgeInsets.only(left:20.0,right: 20.0,bottom: 15.0),
//                    child: Container(width: double.infinity,height: 0.15,color: colorStyle.primaryColor,),
//                  ),
//                  Text("Register",style: TextStyle(color: colorStyle.primaryColor,fontSize: 17.0,fontWeight: FontWeight.w800),),
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
    Function textCapture,
    Widget widgetIcon,
  }) {
    return Column(
      children: <Widget>[
        Container(
          height: 53.5,
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
                  onChanged: textCapture,
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
