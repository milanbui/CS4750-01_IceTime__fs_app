import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/forgot_password_screen.dart';
import 'package:ice_time_fs_practice_log/bottom_navigation_bar_state.dart';
import 'package:ice_time_fs_practice_log/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_image.png', height:200, width: 200),
              Container(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Column(
                  children: <Widget> [
                    SizedBox(height: 15),
                    TextField(
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
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
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
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Color(0xFF7C7C7C),
                        onSurface: Colors.red,
                      ),
                      child: Text("forgot password?", style: TextStyle(fontSize: 15)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF799FDA),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        minimumSize: Size(150, 35),
                      ),
                      child: Text("log in", style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BottomNavBarState()),
                          );
                        })
                        .catchError((error) {
                          showErrorAlertDialog(context, error.toString());
                        });
                      },
                    ),
                    SizedBox(height: 125)
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(90, 0, 0, 20),
                  child: Row(
                      children: <Widget> [
                        Text("don't have an account? ", style: TextStyle(fontSize: 15, color: Color(0xFF7C7C7C))),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Color(0xFF799FDA),
                            onSurface: Colors.red,
                          ),
                          child: Text("sign up", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                        ),

                      ]
                  )
              )
              ],
          )
      ),
    );
  }
}