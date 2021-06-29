import 'package:sourcecodexchange/screen/Bottom_Nav_Bar/custom_nav_bar.dart';
import 'package:sourcecodexchange/screen/home/home.dart';
import 'package:sourcecodexchange/screen/market/markets.dart';
import 'package:sourcecodexchange/screen/news/news_home.dart';
import 'package:sourcecodexchange/screen/setting/setting.dart';
import 'package:sourcecodexchange/screen/setting/themes.dart';
import 'package:sourcecodexchange/screen/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:sourcecodexchange/component/style.dart';
import 'package:sourcecodexchange/screen/wallet/allaccount.dart';

class bottomNavBar extends StatefulWidget {

  ///
  /// Function themeBloc for get data theme from main.dart for double theme dark and white theme
  ///
  ThemeBloc themeBloc;
  bottomNavBar({this.themeBloc});

  _bottomNavBarState createState() => _bottomNavBarState(themeBloc);
}

class _bottomNavBarState extends State<bottomNavBar> {
 ThemeBloc _themeBloc;
 _bottomNavBarState(this._themeBloc);
  int currentIndex = 0;
  bool _color =true;
  Widget callPage(int current){
    switch (current) {
       case 0:
        return new home();
        break;
      case 1:
      return new market();
        break;
      case 2:
      return new WalletMain();
        break;
        case 3:
      return new news();
        break;
      case 4:
     return new settings(themeBloc :_themeBloc);
        break;
      default: 
      return new home();
    }
  }

 
   @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       body: callPage(currentIndex),


        bottomNavigationBar: BottomNavigationDotBar ( // Usar -> "BottomNavigationDotBar"
        color: Theme.of(context).hintColor,
      items: <BottomNavigationDotBarItem>[
        BottomNavigationDotBarItem(icon: Icons.home, onTap: () { setState(() {
         currentIndex = 0;
        }); }),
        BottomNavigationDotBarItem(icon: Icons.account_balance, onTap: () { setState(() {
         currentIndex = 1;
        }); }),
         BottomNavigationDotBarItem(icon: Icons.account_balance_wallet, onTap: () { setState(() {
         currentIndex = 2;
        }); }),  
         BottomNavigationDotBarItem(icon: Icons.library_books, onTap: () { setState(() {
        currentIndex = 3;
        }); }),
         BottomNavigationDotBarItem(icon: Icons.person, onTap: () { setState(() {
         currentIndex = 4;
        }); }), 
         ]
  ),

    );
  }
}