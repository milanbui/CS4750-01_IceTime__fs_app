import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/Screens/account_screen.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';
class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
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
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountScreen()),
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Color(0xFF454545),
                  iconSize: 35,
                  focusColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 325, 0),
                ),
                SizedBox(height: 50),
                Text("Change Email", style: TextStyle(color: Color(0xFF799FDA), fontWeight: FontWeight.bold, fontSize: 25)),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        controller: newEmailController,
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
                          labelText: 'new email',
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
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF799FDA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    minimumSize: Size(150, 35),
                  ),
                  child: Text("done", style: TextStyle(fontSize: 18)),
                  onPressed: () {

                    AuthCredential credential = EmailAuthProvider.credential(
                        email: emailController.text,
                        password: passwordController.text);
                    FirebaseAuth.instance.currentUser!
                        .reauthenticateWithCredential(credential)
                        .then((value) {
                      value.user!.updateEmail(newEmailController.text)
                          .then((value) {
                        showSuccessAlertDialog(
                            context, "Your email has been updated.",
                            "account");
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

