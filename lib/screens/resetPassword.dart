import 'package:final_project/screens/loginScreen.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:toast/toast.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({ required this.email});
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isLoading = false;
  bool desplayBtn = true;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rePasswordController = new TextEditingController();
  @override
  void initState() {
    rePasswordController.addListener(() {
      if (passwordController.text == rePasswordController.text) {
        setState(() {
          desplayBtn = false;
        });
      } else {
        setState(() {
          desplayBtn = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          //text
          //text
          //logo
          Image.asset(
            'assets/images/headerlogo.png',
            width: 150,
            height: 150,
          ),

          SizedBox(
            height: 15,
          ),
          Text(
            'Set your Password',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
          ),
          SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 10,
          ),
          Card(
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusColor: Theme.of(context).backgroundColor,
                  prefixIcon: Icon(Ionicons.lock_open_outline),
                  labelText: 'Enter a new password',
                  border: InputBorder.none),
            ),
          ),
          Card(
            child: TextFormField(
              controller: rePasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusColor: Theme.of(context).backgroundColor,
                  prefixIcon: Icon(Ionicons.lock_open_outline),
                  labelText: 'Re-enter the password',
                  border: InputBorder.none),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 10,
          ),

          Container(
            height: 50,
            child: RaisedButton(
              onPressed: desplayBtn
                  ? null
                  : () {
                      setState(() {
                        isLoading = true;
                      });
                      successFunctio();
                      // ignore: unrelated_type_equality_checks
                    },
              elevation: 10,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  successFunctio() {
    if (passwordController.text.length < 5 ||
        rePasswordController.text.length < 5) {
      Toast.show('This password very weak', context,
          backgroundColor: Colors.red,
          gravity: Toast.TOP,
          duration: Toast.LENGTH_LONG,
          backgroundRadius: 8.0);
      setState(() {
        isLoading = false;
      });
    } else if (rePasswordController.text != passwordController.text) {
      setState(() {
        isLoading = false;
        desplayBtn = true;
      });
    } else {
      PostViewModel postViewModel = new PostViewModel();

      postViewModel
          .resetPassword(widget.email, passwordController.text)
          .then((value) {
        if (value == 'success') {
          Toast.show('Reset Password', context,
              backgroundColor: Colors.green,
              gravity: Toast.TOP,
              duration: Toast.LENGTH_LONG,
              backgroundRadius: 8.0);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => new LoginScreen(playerID: '',)),
            (Route<dynamic> route) => false,
          );
        }
      });
    }
  }
}
