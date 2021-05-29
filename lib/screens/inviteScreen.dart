import 'package:clipboard/clipboard.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/lostConnection.dart';
import 'package:final_project/services/checkConnection.dart';
import 'package:final_project/services/postViewModel.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class InviteFriends extends StatefulWidget {
  @override
  _inviteFriendsState createState() => _inviteFriendsState();
}

class _inviteFriendsState extends State<InviteFriends> {
   String name = '';
  String referralLink = "";
  Future<String> sharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name')!;
    });
    return name;
  }

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

    PostViewModel postViewModel = new PostViewModel();
    sharedPreferences().then((value) {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Freinds'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image.asset(
              'assets/images/invitation.png',
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.25,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              'invite your friends to join Book-Your-Train now',
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: RaisedButton(
                elevation: 10,
                shape: new RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 0.5),
                    borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  Share.share('join to us in Book-Your-Train now ');
                },
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(bottom:8.0,top: 8.0),
                  child: Text('Invite now',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
