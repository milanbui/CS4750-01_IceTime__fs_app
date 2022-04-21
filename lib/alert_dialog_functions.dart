import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/account_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/login_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/splash_screen.dart';

showSuccessAlertDialog(BuildContext context, String text, String page) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("ok", style: TextStyle(color: Color(0xFF799FDA), fontSize: 18)),
    onPressed: () {
      if(page == "sign up") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
      else if(page == "account") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
      }
      else if(page == "delete") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen(title: "title"))
        );
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
      title: Text("Success!"),
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF98BEEB), fontSize: 20),
      content: Text(text),
      actions: [
        okButton,
      ],
      backgroundColor: Color(0xFFE5E5E5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      )
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showErrorAlertDialog(BuildContext context, String error) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("ok", style: TextStyle(color: Color(0xFF799FDA), fontSize: 18)),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
      title: Text("ERROR"),
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
      content: Text(error),
      actions: [
        okButton,
      ],
     // backgroundColor: Color(0xFFE5E5E5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      )
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}