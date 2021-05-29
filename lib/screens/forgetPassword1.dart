import 'dart:math';

import 'package:final_project/screens/forgetPassword.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ForgetPassword1 extends StatefulWidget {
  @override
  _ForgetPassword1State createState() => _ForgetPassword1State();
}

class _ForgetPassword1State extends State<ForgetPassword1> {
  TextEditingController emailController = new TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //logo

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),

            Container(

              width: size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset('assets/images/logo.png'),),

            SizedBox(
              height: 15,
            ),
            Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),

            //text

            Text(
              'Enter your Book-Your-Train email and we`ll',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),

            SizedBox(
              height: 5,
            ), //text
            Text(
              'send you a 6 digit code',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),

            SizedBox(
              height: 20,
            ),
            Card(
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusColor: Theme.of(context).backgroundColor,
                    prefixIcon: Icon(Ionicons.mail_outline),
                    labelText: 'Email',
                    border: InputBorder.none),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  // ignore: unrelated_type_equality_checks
                  setState(() {
                    isLoading = true;
                  });
                  PostViewModel postViewModel = new PostViewModel();
                  int min =
                  100000; //min and max values act as your 6 digit range
                  int max = 999999;
                  var randomizer = new Random();
                  var rNum =
                      min + randomizer.nextInt(max - min);
                  postViewModel
                      .forgetPassword(emailController.text)
                      .then((value) {
                    String email = value.email;
                    String code = rNum.toString();

                    print('hhhhhhhhh:${value.status}');
                    if (value.status == 'success') {

                      print('hhhhhhhhh:${value.email}');
                      postViewModel
                          .sendEmail(rNum.toString(), emailController.text,
                              "Reset Account Password")
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        print('hhhhhhhhh:${value}');
                        if (value == 'success') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new ForgetPassword(
                                        email: emailController.text,
                                        code: code, playerID: '', referralUser: '',
                                      )));
                        }
                      });
                    }
                  });
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
                        'Send Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
