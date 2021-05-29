import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:final_project/screens/lostConnection.dart';
import 'package:final_project/screens/registerScreen.dart';
import 'package:final_project/screens/searchScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_project/services/checkConnection.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:toast/toast.dart';

import 'mainScreen.dart';

class VerificationScreen extends StatefulWidget {
  final String code;
  final String email;
  final String referralUser;
  final String playerID;
  final String name;
  final String password;

  const VerificationScreen(
      {
      required this.code,
      required this.email,
      required this.referralUser,
      required this.playerID,
      required this.name,
      required this.password})
      ;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isCodeSent = false;
  String result = "";
  bool referral = false;
  late PostViewModel postViewModel;
  String code = "";

  CheckConnection checkConnection = new CheckConnection();
  currentStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      checkConnection.internetConnection(context).then((value) {
        if (value == 'error') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => new LostConnection()),
            (Route<dynamic> route) => false,
          );
        }
      });
    } else {
      // I am connected to a wifi network.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new LostConnection()),
        (Route<dynamic> route) => false,
      );
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => new LostConnection()),
                (Route<dynamic> route) => false,
              );
            }
          });
          print('internet connection:$result');
          break;
        case ConnectivityResult.mobile:
          checkConnection.internetConnection(context).then((value) {
            if (value == 'error') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => new LostConnection()),
                (Route<dynamic> route) => false,
              );
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
    String test = widget.email;
    int numSpace = 12;
    setState(() {
      result = test.replaceRange(0, numSpace, '*' * numSpace);
    });
    if (widget.referralUser != null) {
      setState(() {
        referral = true;
      });
    }

    super.initState();
    /* _onVerifyCode(); */
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              width: double.infinity,
              height: size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                  ),
                  Center(
                    child: Text('Smart Realway 2021',
                        style: GoogleFonts.elMessiri(fontSize: 30,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Enter your code',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold,
                          color:Theme.of(context).accentColor,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 0.6,
                    child: Text(
                      'We have sent you a Email with 6 digit verification code',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.black,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //OTP Container
                        Container(
                          width: size.width * 0.6, //0.12
                          height: size.height * 0.1,

                          child: Center(
                            child: PinCodeFields(
                              keyboardType: TextInputType.number,
                              borderColor: Colors.black,
                              fieldWidth: 10,
                              length: 6,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  !.copyWith(color: Theme.of(context).accentColor),
                              animationDuration:
                                  const Duration(milliseconds: 100),
                              animationCurve: Curves.easeInOut,
                              switchInAnimationCurve: Curves.easeIn,
                              switchOutAnimationCurve: Curves.easeOut,
                              animation: Animations.SlideInDown,
                              onComplete: (output) {
                                setState(() {
                                  code = output;
                                });
                                if (widget.code == output) {
                                  print('email:: $output ${widget.code}');
                                } else {
                                  Toast.show("Invalid OTP", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.TOP);
                                }
                                print(output);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width * 0.35,
                    height: 40,
                    child: RaisedButton(
                      hoverColor: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blue)),
                      color: Theme.of(context).accentColor,
                      elevation: 10,
                      onPressed: () {
                        if (widget.code == code) {
                          successFunctio();
                        } else {
                          Toast.show('please check your code again', context,
                              backgroundColor: Colors.red,
                              gravity: Toast.TOP,
                              duration: Toast.LENGTH_LONG,
                              backgroundRadius: 8.0);
                        }
                      },
                      child: Text(
                        'Verify',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "I didn't receive a code !",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  !.copyWith(fontSize: 18, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                postViewModel
                    .sendEmail(widget.code, widget.email, "Tapyo Verification")
                    .then((value) {
                  if (value == 'success') {
                    Toast.show('please check Mail now', context,
                        backgroundColor: Colors.green,
                        gravity: Toast.TOP,
                        duration: Toast.LENGTH_LONG,
                        backgroundRadius: 8.0);
                  } else {
                    Toast.show('please try again later', context,
                        backgroundColor: Colors.red,
                        gravity: Toast.TOP,
                        duration: Toast.LENGTH_LONG,
                        backgroundRadius: 8.0);
                  }
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Text(
                  'Resend',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      !.copyWith(fontSize: 20, color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  successFunctio() {
    PostViewModel postViewModel = new PostViewModel();

    postViewModel.activeAccount(widget.name).then((value) {
      if (value == 'success') {
        postViewModel.login(widget.name, widget.password).then((value) {
          if (value.status == 'active') {
            Toast.show('verification successfully', context,
                backgroundColor: Colors.green,
                gravity: Toast.TOP,
                duration: Toast.LENGTH_LONG,
                backgroundRadius: 8.0);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> new MainScreen()), (route) => false);

          } else {
            Toast.show(value.status, context,
                backgroundColor: Colors.red,
                gravity: Toast.TOP,
                duration: Toast.LENGTH_LONG,
                backgroundRadius: 8.0);
            if(value.status == 'unactive'){

              int min =
              100000; //min and max values act as your 6 digit range
              int max = 999999;
              var randomizer = new Random();
              var rNum =
                  min + randomizer.nextInt(max - min);
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
            }else{
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    new SignUpScreen(playerID: value.playerID, referralUser: '')),
                    (Route<dynamic> route) => false,
              );
            }
          }
        });
      }
    });
  }
}
