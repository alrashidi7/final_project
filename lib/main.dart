// @dart=2.9

import 'dart:async';
import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:final_project/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:final_project/screens/registerScreen.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:final_project/screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Reilway 2021',
      theme: ThemeData(
        primaryColor: Color(0xffe04622),
        accentColor: Color(0xff314555),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Smart Reilway 2021'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title;

  const MyHomePage({Key key,  this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   String id;
  String playerID = "";
  Future<String> initOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("cbc5d9a0-aed9-4020-b000-6a53d1ddc7e2", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    var status = await OneSignal.shared.getPermissionSubscriptionState();
    setState(() {
      playerID = status.subscriptionStatus.userId;
      print('playerID:: ${status.subscriptionStatus.userId}');
    });

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
    });
    return status.subscriptionStatus.userId;
  }

   Widget nextPage;
  bool checkDeepLink = false;
  PostViewModel postViewModel = new PostViewModel();
  String name = "";

  sharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name');
      print('name:::::$name');
      if (name != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    print("playerID SIGN::  || $playerID");
    initOneSignal().then((value) {
      print("playerID SIGN future::  || $value");
      setState(() {
        playerID = value;
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    sharedPreferences();
    /* Timer(Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpScreen(playerID: playerID)),
        (Route<dynamic> route) => false,
      );
    }); */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Carousel(
                  boxFit: BoxFit.cover,
                  autoplay: true,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 6.0,
                  dotIncreasedColor: Theme.of(context).primaryColor,
                  dotBgColor: Colors.transparent,
                  dotPosition: DotPosition.topRight,
                  dotVerticalPadding: 10.0,
                  showIndicator: true,
                  indicatorBgPadding: 7.0,
                  images: [
                    Image.network(
                        'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80',
                        fit: BoxFit.cover),
                    Image.network(
                        'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80',
                        fit: BoxFit.cover),
                    Image.network(
                        'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80',
                        fit: BoxFit.cover),
                    Image.network(
                        'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80s',
                        fit: BoxFit.cover),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height * 0.165,
              color: Colors.black.withOpacity(0.2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width * 0.3,
                            child: RaisedButton(
                              elevation: 10,
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen(playerID: playerID),
                                    ));
                              },
                              child: Text('Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                      fontSize: 16
                                  )),
                            ),
                          ),
                          Container(
                            width: size.width * 0.3,
                            child: RaisedButton(
                              elevation: 10,
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpScreen(playerID: playerID, referralUser: '',),
                                    ));
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                      fontSize: 16
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: size.width -30,
                        child: Container(
                          width: size.width * 0.4,
                          child: RaisedButton(
                            elevation: 10,
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> new MainScreen()), (route) => false);
                            },
                            child: Text('As Geust',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                                )),
                          ),
                        ),
                      ),
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
}
