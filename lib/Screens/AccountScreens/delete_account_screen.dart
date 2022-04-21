import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/Screens/account_screen.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../bottom_navigation_bar_state.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

    User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height:30),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Color(0xFF454545),
                  iconSize: 35,
                  focusColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 325, 0),
                ),
                SizedBox(height: 50),
                Text("Delete Account", style: TextStyle(color: Color(0xFF799FDA), fontWeight: FontWeight.bold, fontSize: 25)),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text("After you delete an account, it's permanently deleted. Accounts can't be undeleted.", style: TextStyle(color: Color(0xFF454545), fontSize: 16)),
                      SizedBox(height: 25),
                      TextField(
                        controller: emailController,
                        obscureText: false,
                        enabled: true,
                        decoration: InputDecoration(
                          border:
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'email',
                          labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        enabled: true,
                        decoration: InputDecoration(
                          border:
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'password',
                          labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).viewInsets.bottom == 0) ? 350 : 100),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    minimumSize: Size(150, 35),
                  ),
                  child: Text("delete account", style: TextStyle(fontSize: 18)),
                  onPressed: () {

                    AuthCredential credential = EmailAuthProvider.credential(
                        email: emailController.text,
                        password: passwordController.text);
                    FirebaseAuth.instance.currentUser!
                        .reauthenticateWithCredential(credential)
                        .then((value) {
                          var id = FirebaseAuth.instance.currentUser!.uid;
                          print(id);
                          value.user!.delete()
                          .then((value) {

                            FirebaseDatabase.instance.ref("users/" + id).remove()
                            .then((value) {
                              showSuccessAlertDialog(
                                  context, "Your account has been deleted.",
                                  "delete");
                            })
                            .catchError((error) {
                              showErrorAlertDialog(context, error.toString());
                            });

                          })
                          .catchError((error) {
                            showErrorAlertDialog(context, error.toString());
                          });
                        })
                        .catchError((error) {
                          showErrorAlertDialog(context, error.toString());
                        });

                  },
                ),
              ]
          )
      ),
    );
  }
}