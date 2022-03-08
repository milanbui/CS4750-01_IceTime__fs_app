import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/login_screen.dart';

showSuccessAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("continue", style: TextStyle(color: Color(0xFF799FDA), fontSize: 18)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
      title: Text("Success!"),
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF98BEEB), fontSize: 20),
      content: Text("Congratulations, your account has been successfully created."),
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