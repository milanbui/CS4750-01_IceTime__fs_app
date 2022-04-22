import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../userInfo.dart';

class PracticeLogScreen extends StatefulWidget {
  @override
  _PracticeLogScreenState createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {
  bool _isEditMode = false;
  List _logsList = CurrentUserInfo.getPracticeLogs();

  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(160, 25, 50, 5),
                        child: Image.asset('assets/images/logo_image.png', height:60, width: 60),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          color: Color(0xFF454545),
                          focusColor: Colors.white,
                          onPressed: () {
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 25, 10, 5),
                        child: IconButton(
                          icon: _isEditMode ? Icon(Icons.done) : Icon(Icons.edit),
                          color: Color(0xFF454545),
                          focusColor: Colors.white,
                          onPressed: () {
                            _changeMode();
                          },
                        ),
                      ),
                    ]
                ),
                Expanded(
                  flex: 80,
                  child: ListView.builder(
                    itemCount: _logsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            Text(_logsList[index]['date'].toString()),
                            Text(_logsList[index]['hours'].toString()),
                            Text(_logsList[index]['notes'].toString()),
                          ],
                        )
                      );
                    },

                  ),
                )
              ]
          )
      ),
    );
  }
}
