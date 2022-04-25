import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/Screens/PracticeLogScreens/add_practice_log_screen.dart';

import 'PracticeLogScreens/edit_practice_log_screen.dart';


class PracticeLogScreen extends StatefulWidget {
  @override
  _PracticeLogScreenState createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {
  bool _isEditMode = false;
  List _logsList =  [];
  bool _progressController = true;

  @override
  void initState() {
    super.initState();

    String id =  FirebaseAuth.instance.currentUser!.uid;
    List temp = [];
    FirebaseDatabase.instance.ref("users/" + id + "/logs").onValue.listen((DatabaseEvent event) {
      setState(() {
        _logsList = [];
        for(DataSnapshot data in event.snapshot.children.toList()) {
          _logsList.add(data.value);
        }

        _progressController = false;
      });
    });

  }

  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8DDFD),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(150, 25, 100, 5),
                        child: Image.asset('assets/images/logo_image.png', height:60, width: 60),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          color: const Color(0xFF454545),
                          focusColor: Colors.white,
                          onPressed: ()  {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddPracticeLogScreen()));
                          },
                        ),
                      ),
                    ]
                ),
                Expanded(
                  flex: 80,
                  child: _progressController ?
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 290, 10, 290),
                      child: CircularProgressIndicator(color: Color(0xFF454545))
                  ) :
                  ListView.builder(
                    itemCount: _logsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditPracticeLogScreen(_logsList[index]['date'].toString())));
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF98BEEB),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                  child: Text("DATE: " + _logsList[index]['date'].toString())
                              ),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Text(
                                      "HOURS: " + _logsList[index]['hours'].toString() + (_logsList[index]['hours'] == 1 ? "hr" : " hrs")
                                  )
                              ),
                              Container(
                                  constraints: BoxConstraints(maxHeight: 55),
                                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                                  child: Text("NOTES:\n" + _logsList[index]['notes'].toString())
                              ),

                            ],
                          )
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
