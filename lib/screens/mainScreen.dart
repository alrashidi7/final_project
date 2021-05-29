import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:final_project/widgets/drawerMenuWidget.dart';
import 'package:final_project/widgets/mainWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  List<Widget> pages = <Widget>[];
  @override
  void initState() {
    pages = [
      /* 
      ProfileScreen(),
       AddFriends("") */
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SliderMenuContainer(
          shadowSpreadRadius: 20,
          drawerIconColor: Colors.white,
          appBarColor: Theme.of(context).accentColor,
          key: _key,
          isShadow: false,
          appBarPadding: const EdgeInsets.only(top: 25),
          sliderMenuOpenSize: size.width * 0.8,
          appBarHeight: size.height * 0.11,
          title: Container(
              width: size.width,
              child: Image.asset('assets/images/logo.png',color: Colors.white,)),
          sliderMenu: DrawerMenuWidget(),
          sliderMain: MainWidget()),
    );
  }
}
