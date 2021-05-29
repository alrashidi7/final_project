import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:final_project/models/userModel.dart';
import 'package:final_project/screens/loginScreen.dart';
import 'package:final_project/screens/lostConnection.dart';
import 'package:final_project/screens/verificationCodeScreen.dart';
import 'package:final_project/services/checkConnection.dart';
import 'package:final_project/services/notification.dart';
import 'package:final_project/services/postviewmodel.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  final String playerID;
  final String referralUser;

  const SignUpScreen({required this.playerID, required this.referralUser})
      ;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController nationalIDController = new TextEditingController();
  TextEditingController visaCardController = new TextEditingController();

  late String phoneNumber;
  late String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneIsoCode = isoCode;
      phoneNumber = internationalizedPhoneNumber;
      print("phones:: $isoCode $phoneNumber");
    });
  }

  bool isPressrd = false;
  String dynamicLink = "";
  String userID = "";
  String playerID = "";
  String stregth = "";
  String yourURL = "";
  bool isReferral = false;
  bool isLoading = false;
  bool obscureText = true;
  late PostViewModel postViewModel;
  UserModel userModel = new UserModel(email: '', id: '', name: '', nationalID: '', password: '', phone: '', playerID: '', status: '',  visaCard: '', statusAccount: '');

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
    });

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
    });
    return status.subscriptionStatus.userId;
  }

  String name = '';
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.clear();

    super.dispose();
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

    nameController.addListener(() {
      //here you have the changes of your textfield
      print("value: ${nameController.text}");
      setState(() {
        name = nameController.text.replaceAll(RegExp(' '), '-');

        print("value:s ${name}");
      });
      //use setState to rebuild the widget
    });
    postViewModel = new PostViewModel();
    setState(() {
      playerID = widget.playerID;
    });
    if (widget.referralUser != null) {
      setState(() {
        print('referral: ${widget.referralUser}');
        isReferral = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("playerID SIGN: ${widget.playerID}");

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: size.height * 0.06,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('you have elready account?', style: TextStyle(fontSize: 17)),
              SizedBox(
                width: 5.0,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              playerID: widget.playerID,
                            ))),
                child: Text(
                  'Login',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
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
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Container(

                      width: size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Image.asset('assets/images/logo.png'),),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text('Create your Account',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: TextFormField(
                        controller: nameController,
                        maxLength: 16,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(

                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Ionicons.person_outline),
                            labelText: 'Username',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Ionicons.call_outline),
                            labelText: 'Phone Number',
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Ionicons.mail_outline),
                            labelText: 'Email',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: TextFormField(
                        controller: nationalIDController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Image.asset('assets/images/passport.png',width: 15,height: 15,
                            ),
                            labelText: 'National ID',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: TextFormField(
                        controller: visaCardController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusColor: Theme.of(context).accentColor,
                            prefixIcon: Icon(Ionicons.card_outline),
                            labelText: 'Visa Card',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                            focusColor: Theme.of(context).accentColor,
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
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: isPressrd
                          ? RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(color: Colors.blue)),
                              onPressed: () {
                                setState(() {
                                  isLoading = false;
                                  isPressrd  = false;
                                });
                              },
                              color: Theme.of(context).accentColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  backgroundColor: Theme.of(context).accentColor,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ))
                          : RaisedButton(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(
                                      color:Colors.blue, width: 2.0)),
                              onPressed: () {
                                /* openUrl(); */

                                if (nameController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    nationalIDController.text.isEmpty ||
                                    visaCardController.text.isEmpty ||
                                    phoneController.text.isEmpty) {
                                  Toast.show(
                                      "please all fields are requird", context,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0,
                                      gravity: Toast.TOP,
                                      backgroundColor: Colors.red);
                                  print('please all fields are requird');
                                } else if (EmailValidator.validate(
                                        emailController.text) ==
                                    false) {
                                  Toast.show("this email address is not valid",
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0,
                                      gravity: Toast.TOP,
                                      backgroundColor: Colors.red);
                                  print("has whitespace");
                                } else if (passwordController.text.length < 5) {
                                  Toast.show(
                                      "this password is very weak..minimum 5 character",
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0,
                                      gravity: Toast.TOP,
                                      backgroundColor: Colors.red);
                                  print('this password is very weak');
                                } else if (visaCardController.text.length <
                                    16) {
                                  Toast.show("this not visa card.. please check it", context,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0,
                                      gravity: Toast.TOP,
                                      backgroundColor: Colors.red);
                                } else if (nationalIDController.text.length <
                                    14) {
                                  Toast.show(
                                      "this not national ID number.. please check it",
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0,
                                      gravity: Toast.TOP,
                                      backgroundColor: Colors.red);
                                  print('this password is very weak');
                                } else if (nameController.text.length > 16) {
                                  Toast.show("this name is very Big", context,
                                      duration: Toast.LENGTH_LONG,
                                      backgroundRadius: 8.0,
                                      gravity: Toast.TOP,
                                      backgroundColor: Colors.red);
                                } else {
                                  setState(() {
                                    //iosUpdate
                                    if (phoneController.text.substring(0, 2) ==
                                        '00') {
                                      phoneController.text = phoneController
                                          .text
                                          .replaceRange(0, 2, '+');
                                    }
                                    isPressrd = true;

                                    setState(() {
                                      initOneSignal().then((value) {
                                        postViewModel
                                            .setUser(
                                                name,
                                                emailController.text,
                                                phoneController.text,
                                                passwordController.text,
                                                widget.playerID,
                                                nationalIDController.text,
                                                visaCardController.text)
                                            .then((value) {
                                          setState(() {
                                            userModel = value;
                                          });
                                          if (value.status ==
                                              'registeration success') {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            int min =
                                            100000; //min and max values act as your 6 digit range
                                            int max = 999999;
                                            var randomizer = new Random();
                                            var rNum =
                                                min + randomizer.nextInt(max - min);
                                            postViewModel
                                                .sendEmail(
                                                    rNum.toString(),
                                                    emailController.text,
                                                    "Smart Realway Verification")
                                                .then((value) {
                                              if (value == 'success') {
                                                Notifications notification =
                                                    new Notifications();
                                                initOneSignal().then((value) {
                                                  notification.postNotification(
                                                      value,
                                                      "Welcome $name in Smart Realway 2021 ",
                                                      "You can now search about train times and book it also, from your home easily and in a manner befitting of 2021");
                                                });
                                                setState(() {
                                                  isLoading = false;
                                                  print('firstItem: $value');
                                                });
                                                Timer(Duration(seconds: 3), () {
                                                  print(
                                                      'usersss: ${userModel.password}');
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            new VerificationScreen(
                                                                code: rNum.toString(),
                                                                playerID:
                                                                    userModel
                                                                        .playerID,
                                                                name: userModel
                                                                    .name,
                                                                password:
                                                                    userModel
                                                                        .password,
                                                                email: userModel
                                                                    .email, referralUser: '',)),
                                                    (Route<dynamic> route) =>
                                                        false,
                                                  );
                                                });
                                              }
                                            });

                                            setState(() {
                                              isLoading = false;
                                            });
                                            Toast.show(
                                                userModel.status, context,
                                                backgroundColor: Colors.green,
                                                gravity: Toast.TOP,
                                                duration: Toast.LENGTH_LONG,
                                                backgroundRadius: 8.0);
                                          } else {
                                            setState(() {
                                              isPressrd = false;
                                            });
                                            Toast.show(value.status, context,
                                                backgroundColor: Colors.red,
                                                gravity: Toast.TOP,
                                                duration: Toast.LENGTH_LONG,
                                                backgroundRadius: 8.0);
                                          }
                                        });
                                      });
                                    });
                                  });
                                }
                              },
                              color:Theme.of(context).accentColor,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19.0),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
