import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/AccountScreens/change_password_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/AccountScreens/delete_account_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/splash_screen.dart';
import '../alert_dialog_functions.dart';
import 'AccountScreens/change_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'AccountScreens/change_name_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}


class _AccountScreenState extends State<AccountScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _name = "";

  @override
  void initState() {
    super.initState();

    String id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid +"/name").onValue.listen((DatabaseEvent event) {
      setState(() {
        _name = event.snapshot.value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 35,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                    child: Text(_name,
                      style: TextStyle(
                        fontSize: 28,
                        color: const Color(0xFF454545),
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
                Expanded(
                  flex: 55,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangeNameScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Color(0xFF7C7C7C),
                          onSurface: Colors.red,
                        ),
                        child: Text("Change Name", style: TextStyle(fontSize: 15)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangeEmailScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                            primary: Color(0xFF7C7C7C),
                            onSurface: Colors.red,
                        ),
                        child: Text("Change Email", style: TextStyle(fontSize: 15)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                            primary: Color(0xFF7C7C7C),
                            onSurface: Colors.red,
                        ),
                        child: Text("Change Password", style: TextStyle(fontSize: 15)),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut()
                          .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SplashScreen(title: "")),
                            );
                          })
                          .catchError((error) {
                            showErrorAlertDialog(context, error.toString());
                          });
                        },
                        style: TextButton.styleFrom(
                            primary: Color(0xFF7C7C7C),
                            onSurface: Colors.red,
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0)
                        ),
                        child: Text("Log Out", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex:10,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.red,
                        onSurface: Colors.red,
                    ),
                    child: Text("Delete Account", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]
          )
      ),
    );
  }
}
