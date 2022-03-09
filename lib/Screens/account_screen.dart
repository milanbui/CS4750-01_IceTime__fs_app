import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100),
                CircleAvatar(
                    backgroundColor: Color(0xFF799FDA),
                    // backgroundImage: AssetImage('assets/images/logo_image.png'),
                    radius: 80.0,
                    child: Icon(Icons.person, size: 100, color:Color(0xFFE5E5E5))
                ),
                SizedBox(height:15),
                Text("First Last", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Color(0xFF454545))),
                SizedBox(height:50),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                    primary: Color(0xFF7C7C7C),
                    onSurface: Colors.red,
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
                  ),
                  child: Text("Change Profile Picture", style: TextStyle(fontSize: 15)),
                ),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                      primary: Color(0xFF7C7C7C),
                      onSurface: Colors.red,
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
                  ),
                  child: Text("Change Email", style: TextStyle(fontSize: 15)),
                ),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                      primary: Color(0xFF7C7C7C),
                      onSurface: Colors.red,
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
                  ),
                  child: Text("Change Password", style: TextStyle(fontSize: 15)),
                ),
                SizedBox(height: 150),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.red,
                      onSurface: Colors.red,
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
                  ),
                  child: Text("Delete Account", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ]
          )
      ),
    );
  }
}
