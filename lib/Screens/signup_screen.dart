import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Expanded(
                  // If keyboard is not open, flex 40 else flex 20
                  flex: (MediaQuery.of(context).viewInsets.bottom == 0) ? 40 : 20,
                  child: Image.asset('assets/images/logo_image.png', height:200, width: 200)
              ),
              Expanded( // MAIN SECTION
                // If keyboard is not open, 50 , else 60
                flex: (MediaQuery.of(context).viewInsets.bottom == 0) ? 50 : 60,
                child: Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    children: <Widget> [
                      SizedBox(height: 15),
                      // Name text box
                      TextField(
                        controller: nameController,
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
                          labelText: 'name',
                          labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Email text box
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
                      // Password text box
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
                      SizedBox(height: 10),
                      // Confirm password text box
                      TextField(
                        controller: confirmPasswordController,
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
                          labelText: 'confirm password',
                          labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Sign up button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF799FDA),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          minimumSize: Size(150, 35),
                        ),
                        child: Text("sign up", style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          // If passwords match
                          if(passwordController.text == confirmPasswordController.text) {

                            // Creates user
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text, password: passwordController.text)
                                // If successfully created in firebase authenticate
                                .then((authResult) {

                                  // if user created
                                  if(authResult.user != null) {

                                    var profile = {
                                      "uid" : authResult.user!.uid,
                                      "name" : nameController.text == ""
                                               ? "First Last"
                                               : nameController.text
                                    };

                                    // add profile to firebase realtime database
                                    FirebaseDatabase.instance.ref("users/"+ authResult.user!.uid).set(profile)
                                        .then((value) {
                                      showSuccessAlertDialog(context, "Congratulations, your account has been successfully created.", "sign up");
                                    })
                                        .catchError((error) {
                                      showErrorAlertDialog(context, error.toString());
                                    });
                                  }
                                })
                                .catchError((error) {
                                      showErrorAlertDialog(context, error.toString());
                                });
                          }
                          else{
                            //do not send to firebase and show warning
                            showErrorAlertDialog(context, "Passwords do not match.");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                // Go back to log in
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget> [
                          Text("already have an account? ", style: TextStyle(fontSize: 15, color: Color(0xFF7C7C7C))),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Color(0xFF799FDA),
                              onSurface: Colors.red,
                            ),
                            child: Text("log in", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                          ),
                        ]
                    )
                ),
            ],
          )
      ),
    );
  }
}
