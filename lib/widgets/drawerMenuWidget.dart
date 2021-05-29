import 'package:final_project/models/menuDrawerModel.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/screens/loginScreen.dart';

import '../main.dart';

class DrawerMenuWidget extends StatefulWidget {
  @override
  _DrawerMenuWidgetState createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget> {
  String name = "your Link";
  String email = "your Link";
  String playerID = "";
  bool hasImage = false;
  String imageURL = "";
  late SharedPreferences prefs;

  sharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      imageURL = prefs.getString('imageURL')?? '';
      name = prefs.getString('name') ?? "Guest";

      email = prefs.getString('email') ?? "bookyourtrain@gmail.com";
      playerID = prefs.getString('playerID')?? '';

      if (imageURL == "imageURL") {
        hasImage = false;
      } else {
        hasImage = true;
      }
      print(hasImage);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    sharedPreferences();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Container(
        color: Theme.of(context).accentColor.withOpacity(0.92),
        padding: const EdgeInsets.only(top: 10, left: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.07,
            ),
            Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: 'BalsamiqSans'),
            ),
            Text(
              email,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  fontFamily: 'BalsamiqSans'),
            ),
            SizedBox(
              height: size.height * 0.06,
            ),
            sliderItem("Home", 'home.png', context),
            /* 
            sliderItem('Booking', 'ticket.png', context), */
            name!='Guest'?sliderItem('My Trips', 'destination.png', context):SizedBox()
            ,
            name!='Guest'?sliderItem('Invite Friends', 'invitation.png', context):SizedBox(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.06,
                  child: name == 'Guest' ?RaisedButton(
                    elevation: 10,
                    shape: new RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue, width: 0.5),
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Colors.white,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen(playerID: playerID),
                          ));
                    },
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.login_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Text(
                            "LogIn",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):
                  RaisedButton(
                    elevation: 10,
                    shape: new RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue, width: 0.5),
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Colors.white,
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Log out"),
                            content: Text(
                                "you really want to sign out from this account?"),
                            actions: [
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  prefs.clear();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.logout,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          Text(
                            "Log out",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }

  Widget sliderItem(String title, String imageUrl, BuildContext context) =>
      ListTile(
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.white),
          ),
          leading: Image.asset(
            'assets/images/$imageUrl',
            width: 30,
            height: 30,
          ),
          onTap: () {
            MenuDrawerModel drawerViewModel = new MenuDrawerModel();
            drawerViewModel.onClickItem(title, context, name);
          });
}
