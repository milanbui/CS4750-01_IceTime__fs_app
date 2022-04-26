import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEditMode = false;
  TextEditingController _goalController = TextEditingController();
  int _hoursPracticed = 0;
  int _hoursLeft = 0;
  String _logDate = "";
  String _logHours = "";
  String _logNotes = "";

  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }
  @override
  void initState() {
    super.initState();

    String id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance .ref("users/" + id + "/logs").onValue.listen((DatabaseEvent event) {
      setState(() {
        _logDate = event.snapshot.children.last.child('date').value.toString();
        _logHours = event.snapshot.children.last.child('hours').value.toString();
        _logNotes = event.snapshot.children.last.child('notes').value.toString();
      });
    });

    FirebaseDatabase.instance .ref("users/" + id + "/goal").onValue.listen((DatabaseEvent event) {
      setState(() {
        _goalController = TextEditingController(text: event.snapshot.value.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Padding(
        padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(150, 25, 100, 5),
                            child: Image.asset('assets/images/logo_image.png', height:60, width: 60),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                            child: IconButton(
                              icon: _isEditMode ? Icon(Icons.done) : Icon(Icons.edit),
                              color: Color(0xFF454545),
                              focusColor: Colors.white,
                              onPressed: () {
                                if(_isEditMode) {
                                  FirebaseDatabase.instance .ref("users/" + FirebaseAuth.instance.currentUser!.uid).update({'goal' : _goalController.text})
                                  .catchError((onError) {
                                    showErrorAlertDialog(context, onError.toString());
                                  });
                                }

                                _changeMode();
                              },
                            ),
                          ),
                        ]
                    ),
                  Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Color(0xFF98BEEB),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Weekly Practice Hour Goal: ", style: TextStyle(fontSize: 12, color: Color(0xFF454545))),
                            SizedBox(
                                width: 50,
                                height: 100,
                                child:
                                TextField(
                                  style: TextStyle(color: Color(0xFF454545)),
                                  controller: _goalController,
                                  enabled: _isEditMode,
                                  decoration: InputDecoration(
                                    border:
                                    OutlineInputBorder(
                                      borderSide: _isEditMode ? BorderSide(color: Colors.white) : BorderSide.none ,
                                    ),
                                    filled: false,
                                  ),
                                )
                            )
                          ],
                        )
                    ),
                  SizedBox(height: 5),
                  Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFF98BEEB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Hours Practiced This Week  : ", style: TextStyle(fontSize: 12, color: Color(0xFF454545))),
                            Text(_hoursPracticed.toString(), style: TextStyle(color: Color(0xFF454545))),
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 5),
                  Container(
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFF98BEEB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Hours Until Next Sharpening: ", style: TextStyle(fontSize: 12, color: Color(0xFF454545))),
                            Text(_hoursLeft.toString(), style: TextStyle(color: Color(0xFF454545))),
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 15),
                  Text("Last Practice Log", style: TextStyle(fontSize: 15, color: Color(0xFF454545), fontWeight: FontWeight.bold) ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        color: Color(0xFF98BEEB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                                margin: const EdgeInsets.fromLTRB(15, 15, 15, 8),
                                child: Row(
                                  children: [
                                    Text("DATE: ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF454545))),
                                    Text(_logDate, style: TextStyle(color: Color(0xFF454545)))
                                  ],
                                )
                            ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              child: Row(
                                children: [
                                  Text("HOURS: ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF454545))),
                                  Text(_logHours +  (_logHours == 1 ? "hr" : " hrs"), style: TextStyle(color: Color(0xFF454545))),
                                ],
                              )
                          ),
                          Container(
                              constraints: BoxConstraints(maxHeight: 320),
                              margin: const EdgeInsets.fromLTRB(15, 8, 15, 2),
                              child: Text("NOTES:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF454545))),
                          ),
                          Container(
                            constraints: BoxConstraints(maxHeight: 320),
                            margin: const EdgeInsets.fromLTRB(15, 2, 15, 15),
                            child: Text(_logNotes, style: TextStyle(color: Color(0xFF454545))),
                          ),
                        ],
                      )
                    ),
                ]
              )
            ),
        ),
    );
  }
}
