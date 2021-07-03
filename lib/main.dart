import 'dart:async';
import 'package:sourcecodexchange/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:sourcecodexchange/screen/intro/complete_setup.dart';
import 'package:sourcecodexchange/screen/intro/on_Boarding.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sourcecodexchange/screen/setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sourcecodexchange/screen/home/home.dart';
import 'package:sourcecodexchange/screen/intro/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

/// Run first apps open adb wireless
void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  final Widget child;

  myApp({Key key, this.child}) : super(key: key);

  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  /// Create _themeBloc for double theme (Dark and White theme)
  ThemeBloc _themeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _themeBloc = ThemeBloc();
  }

  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// StreamBuilder for themeBloc
    return StreamBuilder<ThemeData>(
      initialData: _themeBloc.initialTheme().data,
      stream: _themeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'SourceCodeExchange',
          theme: snapshot.data,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(
            themeBloc: _themeBloc,
          ),

          /// Move splash screen to onBoarding Layout
          /// Routes
          ///
          routes: <String, WidgetBuilder>{
            "onBoarding": (BuildContext context) =>
                new onBoarding(themeBloc: _themeBloc)
          },
        );
      },
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  ThemeBloc themeBloc;
  SplashScreen({this.themeBloc});
  @override
  _SplashScreenState createState() => _SplashScreenState(themeBloc);
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  ThemeBloc themeBloc;
  _SplashScreenState(this.themeBloc);
  @override

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), NavigatorPage);
  }

  /// To navigate layout change
  void NavigatorPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = await prefs.getString('id');
    String token = await prefs.getString('token');
    String email = await prefs.getString('email');
    var url = "https://cryptonew-api.herokuapp.com/api/get/user?email=$email"; // iOS



    if(token != null){
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        var st = jsonDecode(response.body);
        var bvnVerification = st["data"]["bvn_verified"];
        print(st);
        print(bvnVerification);
          if(bvnVerification != true){
            Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        SetUp(
                          themeBloc: themeBloc,
                        )));

          } else{
            Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        bottomNavBar(themeBloc: themeBloc)));
          }

      } else {
        var st = jsonDecode(response.body);
        var status = st["message"];
        return status;
      }

    } else if(uid != null){
      Navigator.of(context)
          .pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new LoginNow(
            themeBloc: themeBloc,
          )));
    } else {
      Navigator.of(context).pushReplacementNamed("onBoarding");
    }
  }


  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/splash_screen.png'),
                fit: BoxFit.cover)),
        child: Container(
          /// Set gradient black in image splash screen (Click to open code)
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromRGBO(0, 0, 0, 0.1),
                Color.fromRGBO(0, 0, 0, 0.1)
              ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/image/logo.png", height: 65.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0, top: 7.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Future<String> dataToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  var url = "https://cryptonew-api.herokuapp.com/api/data"; // iOS
  final http.Response response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token
    },
  );

  if (response.statusCode == 200) {
    var st = jsonDecode(response.body);
    var status = st["message"];
    return status;
  } else {
    var st = jsonDecode(response.body);
    var status = st["message"];
    print(status);
    return status;
  }
}