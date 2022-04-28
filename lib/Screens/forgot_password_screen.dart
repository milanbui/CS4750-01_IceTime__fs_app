import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 15,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Color(0xFF454545),
                  iconSize: 35,
                  focusColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 325, 0),
                ),
              ),
              Expanded( // Page description and prompt section
                flex: (MediaQuery.of(context).viewInsets.bottom == 0) ? 40 : 40,
                child: Column(
                  children: [
                    Image.asset('assets/images/forgot_password_icon.png',
                        height: (MediaQuery.of(context).viewInsets.bottom == 0)
                                 ? 200 : 150),
                    SizedBox(height:15),
                    Text("Forgot Your Password?",
                        style: TextStyle(color: Color(0xFF799FDA),
                               fontSize: 28, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Text("Enter the email associated with your account "
                                  "to receive instructions to reset your password.",
                                  style: TextStyle(color: Color(0xFF7C7C7C),
                                                   fontSize: 15)),
                    ),
                  ],
                ),
              ),
              Expanded( // RESET PASSWORD EMAIL SECTION
                flex: (MediaQuery.of(context).viewInsets.bottom == 0) ? 50 : 25,
                child: Column(
                  children: <Widget> [
                    // Email text box
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 20, 25, 10),
                      child: TextField(
                        controller: emailController,
                        obscureText: false,
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
                    ),
                    SizedBox(height: 10),
                    // Send password reset button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF799FDA),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        minimumSize: Size(150, 35),
                      ),
                      child: Text("send email", style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        // Send password reset email
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text)
                            .then((value) {
                          Navigator.pop(context);
                        })
                            .catchError((error) {
                          showErrorAlertDialog(context, error.toString());
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}