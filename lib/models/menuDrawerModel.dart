import 'package:final_project/screens/inviteScreen.dart';
import 'package:final_project/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/searchScreen.dart';

class MenuDrawerModel {
  onClickItem(String name, BuildContext context, String userName) {
    switch (name) {
      case "Home":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
      case "Edit Profile":
        /* 
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfileScreen(name: userName))); */
        break;
      case "Activate":
        /* 
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ActivateScreen())); */

        break;
      case "Read Tapyo":
        /* 
        showModalBottomSheet(
            context: context,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            builder: (BuildContext context) {
              return NFCReader();
            }); */

        break;
        /* case "Booking":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchScreen())); */
        break;
      case "My Trips":
        /* 
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BuyScreen())); */
        break;

      case "Go VIP":
        /* 
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProScreen())); */
        break;
      case "How to Tapyo":
        /* 
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HowToTapyo())); */
        break;

      case "Invite Friends":

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InviteFriends()));
        break;
      case "Log out":
        break;
    }
  }
}
