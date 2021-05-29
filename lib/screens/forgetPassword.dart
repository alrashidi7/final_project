import 'package:connectivity/connectivity.dart';
import 'package:final_project/screens/lostConnection.dart';
import 'package:final_project/screens/resetPassword.dart';
import 'package:final_project/services/checkConnection.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:toast/toast.dart';

class ForgetPassword extends StatefulWidget {
  final String code;
  final String email;
  final String referralUser;
  final String playerID;

  const ForgetPassword(
      {required this.code, required this.email, required this.referralUser, required this.playerID});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isCodeSent = false;
  String result = "";
  bool referral = false;
  late PostViewModel postViewModel;
  String code = "";
  String prevCode = '';
  TextEditingController passwordController = new TextEditingController();

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
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Container(

                  width: size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Image.asset('assets/images/logo.png'),),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  'Enter your code',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
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
                    'We have sent you a Email with 6 digit to reset your password',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.07,
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
                                !.copyWith(color: Theme.of(context).primaryColor,),
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
                  height: size.height * 0.02,
                ),
                Container(
                  width: size.width * 0.45,
                  height: 40,
                  child: RaisedButton(
                    hoverColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.blue)),
                    elevation: 10,
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (widget.code == code) {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResetPassword(email: widget.email)));
                        });
                      } else {
                        Toast.show('please check your code again', context,
                            backgroundColor: Colors.red,
                            gravity: Toast.BOTTOM,
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
                    .sendEmail(
                        widget.code, widget.email, "Reset Account Password")
                    .then((value) {
                  if (value == 'success') {
                    Toast.show('please check Mail now', context,
                        backgroundColor: Colors.green,
                        gravity: Toast.BOTTOM,
                        duration: Toast.LENGTH_LONG,
                        backgroundRadius: 8.0);
                  } else {
                    Toast.show('please try again later', context,
                        backgroundColor: Colors.red,
                        gravity: Toast.BOTTOM,
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
                      !.copyWith(fontSize: 20, color: Theme.of(context).primaryColor,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
