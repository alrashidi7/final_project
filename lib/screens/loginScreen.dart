import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:final_project/screens/forgetPassword1.dart';
import 'package:final_project/screens/lostConnection.dart';
import 'package:final_project/screens/mainScreen.dart';
import 'package:final_project/screens/registerScreen.dart';
import 'package:final_project/screens/verificationCodeScreen.dart';
import 'package:final_project/services/checkConnection.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  final String playerID;

  const LoginScreen({required this.playerID});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isPressed = false;
  bool isloading = false;
  bool isSuccess = false;
  bool obscureText = true;

  String playerID = "";
  String name = "";
  String imageUrl = "";
  late PostViewModel postViewModel;

  CheckConnection checkConnection = new CheckConnection();
  currentStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      checkConnection.internetConnection(context).then((value) {
        if (value == 'error') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new LostConnection(),
              ));
        }
      });
    } else {
      // I am connected to a wifi network.
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new LostConnection(),
          ));
    }
  }

  @override
  void initState() {
    currentStatus();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          checkConnection.internetConnection(context).then((value) {
            if (value == 'error') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new LostConnection(),
                  ));
            }
          });
          print('internet connection:$result');
          break;
        case ConnectivityResult.mobile:
          checkConnection.internetConnection(context).then((value) {
            if (value == 'error') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new LostConnection(),
                  ));
            }
          });

          print('internet connection:$result');
          break;
        case ConnectivityResult.none:
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new LostConnection(),
              ));

          break;
        default:
      }
    });

    postViewModel = new PostViewModel();
    playerID = widget.playerID;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Text('You don`t have Account?! ',
                  style: TextStyle(color: Colors.black87)),
              GestureDetector(
                onTap: () {
                  print('playerID: $playerID');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new SignUpScreen(playerID: playerID, referralUser: '',)));
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(15),
              height: size.height * 0.12,
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          new MyHomePage()));
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 70),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(

                      width: size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        child: Image.asset('assets/images/logo.png'),),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text('Login to Your Account..',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Ionicons.person_outline),
                            labelText: 'Username',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: obscureText
                                  ? Icon(Ionicons.eye_off_outline)
                                  : Icon(Ionicons.eye_outline),
                              onPressed: () {
                                setState(() {
                                  if (obscureText == true) {
                                    obscureText = false;
                                  } else {
                                    obscureText = true;
                                  }
                                });
                              },
                            ),
                            focusColor: Theme.of(context).backgroundColor,
                            prefixIcon: Icon(Ionicons.lock_open_outline),
                            labelText: 'Password',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: () {
                          // ignore: unrelated_type_equality_checks
                          if (nameController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Toast.show("please all fields are requird", context,
                                duration: Toast.LENGTH_LONG,
                                backgroundRadius: 8.0,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Colors.red);
                            print('please all fields are requird');
                          } else {
                            setState(() {
                              isloading = true;
                            });
                            postViewModel
                                .login(
                                    nameController.text, passwordController.text)
                                .then((value) {
                              setState(() {
                                isloading = false;
                              });
                              Toast.show(value.status, context,
                                  backgroundColor: Colors.red,
                                  gravity: Toast.BOTTOM,
                                  duration: Toast.LENGTH_LONG,
                                  backgroundRadius: 8.0);

                              int min =
                              100000; //min and max values act as your 6 digit range
                              int max = 999999;
                              var randomizer = new Random();
                              var rNum =
                                  min + randomizer.nextInt(max - min);

                              switch (value.status) {
                                case 'active':
                                  name = value.name;
                                  /* imageUrl = value.imageURL; */
                                  isloading = false;
                                  isSuccess = true;
                                  Toast.show(value.status, context,
                                      backgroundColor: Colors.green,
                                      gravity: Toast.BOTTOM,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0);
                                  Timer(Duration(seconds: 2), () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()),
                                      (Route<dynamic> route) => false,
                                    );
                                  });
                                  break;
                                case 'this account is created but not virefication':

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new VerificationScreen(
                                                code: rNum.toString(),
                                                playerID: value.playerID,
                                                email: value.email, name: '', password: '', referralUser: '',)),
                                    (Route<dynamic> route) => false,
                                  );
                                  break;
                                case 'your password or username incorrect':
                                  Toast.show(value.status, context,
                                      backgroundColor: Colors.red,
                                      gravity: Toast.BOTTOM,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0);
                                  break;
                                default:
                              }
                            });
                          }
                        },
                        elevation: 10,
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: isloading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new ForgetPassword1()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
          isSuccess
              ? Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Card(
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            width: size.width * 0.25,
                            height: size.width * 0.25,
                            decoration: new BoxDecoration(

                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(50.0)),
                              border: new Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: Image.asset(
                                'assets/images/suit.png',),
                          ),
                          Text(
                            '\nwelcome back',
                            style: TextStyle(
                                color: Theme.of(context).accentColor),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
