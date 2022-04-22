import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/Screens/add_practice_log_screen.dart';

import '../userInfo.dart';

class PracticeLogScreen extends StatefulWidget {
  @override
  _PracticeLogScreenState createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {
  bool _isEditMode = false;
  List _logsList =  CurrentUserInfo.getPracticeLogs();

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddPracticeLogScreen())
                            ).then((value) => setState(()async {_logsList =  await CurrentUserInfo.getPracticeLogs();}));
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
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF98BEEB),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                                child: Text("DATE: " + _logsList[index]['date'].toString())
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                child: Text(
                                    "HOURS: " + _logsList[index]['hours'].toString() + (_logsList[index]['hours'] == 1 ? "hr" : " hrs")
                                )
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                                child: Text("NOTES:\n" + _logsList[index]['notes'].toString())
                            ),

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
