import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PracticeLogScreen extends StatefulWidget {
  @override
  _PracticeLogScreenState createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {

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
                Image.asset('assets/images/fs_logo.png', height:60, width: 60),
                Container(
                  height: 300,
                  width: 350,
                )
              ]
          )
      ),
    );
  }
}
