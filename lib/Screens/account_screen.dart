import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/AccountScreens/change_password_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/AccountScreens/delete_account_screen.dart';
import 'AccountScreens/change_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100),
                CircleAvatar(
                    backgroundColor: Color(0xFF799FDA),
                    radius: 80.0,
                    child: Icon(Icons.person, size: 100, color:Color(0xFFE5E5E5))
                ),
                SizedBox(height:15),
                Text(_name,
                  style: TextStyle(
                    fontSize: 28,
                    color: const Color(0xFF454545),
                    fontWeight: FontWeight.bold,
                  ),),
                SizedBox(height:50),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                    primary: Color(0xFF7C7C7C),
                    onSurface: Colors.red,
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
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
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
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
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0)
                  ),
                  child: Text("Change Password", style: TextStyle(fontSize: 15)),
                ),
                SizedBox(height: 150),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeleteAccountScreen()),
                    );
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
