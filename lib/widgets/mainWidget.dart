import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:final_project/screens/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int bottomNavIndex = 0;
  List<Widget> screens = <Widget>[];
  @override
  void initState() {
    screens = [
      SearchScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Theme.of(context).accentColor,
        items: <Widget>[
          Icon(Ionicons.search_outline, color: Colors.white, size: 30),
          Icon(Icons.list, color: Colors.white, size: 30),
          Icon(Icons.compare_arrows, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
          bottomNavIndex = index;
        },
      ), */
      body: screens[bottomNavIndex],
    );
  }
}
