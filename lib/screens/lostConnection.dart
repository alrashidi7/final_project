import 'package:connectivity/connectivity.dart';
import 'package:final_project/services/checkConnection.dart';
import 'package:flutter/material.dart';

class LostConnection extends StatefulWidget {
  @override
  _LostConnectionState createState() => _LostConnectionState();
}

class _LostConnectionState extends State<LostConnection> {
  bool connected = false;
  CheckConnection checkConnection = new CheckConnection();
  currentStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      checkConnection.internetConnection(context).then((value) {
        if (value == 'done') {
          Navigator.pop(context);
        }
      });
    } else {}
  }

  @override
  void initState() {
    currentStatus();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          checkConnection.internetConnection(context).then((value) {
            if (value == 'done') {
              Navigator.pop(context);
            }
          });
          print('internet connection:$result');
          break;
        case ConnectivityResult.mobile:
          checkConnection.internetConnection(context).then((value) {
            if (value == 'done') {
              Navigator.pop(context);
            }
          });

          print('internet connection:$result');
          break;
        case ConnectivityResult.none:
          break;
        default:
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no.wifi.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  " Whooops...\n no internet connection found.please check your connection and try again",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 150,
              child: RaisedButton(
                onPressed: () {},
                child: Text('Try again'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
