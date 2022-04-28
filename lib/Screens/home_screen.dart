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
  int _hoursLeft = 50;
  int _lastSharpenDate = -1;
  String _logDate = "";
  String _logHours = "";
  String _logNotes = "";
  bool _progressController = true;


  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  void initState() {
    super.initState();
    String id = FirebaseAuth.instance.currentUser!.uid;



    FirebaseDatabase.instance .ref("users/" + id + "/goal").onValue.listen((DatabaseEvent event) {
      if(event.snapshot.value != null) {
        setState(() {
          _goalController =
              TextEditingController(text: event.snapshot.value.toString());

          _progressController = false;
        });
      }
      else {
        setState(() {
          _progressController = false;
        });
      }
    });

    FirebaseDatabase.instance .ref("users/" + id + "/lastSharpenDate").onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          print(int.tryParse(event.snapshot.value.toString()));
          _lastSharpenDate = int.parse(event.snapshot.value.toString());

          _progressController = false;
        });
      }
      else {
        setState(() {
          _progressController = false;
        });
      }
    });

    FirebaseDatabase.instance .ref("users/" + id + "/logs").onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(()  {
          DateTime date = DateTime.now();
          DateTime firstDayOfWeek = DateTime(date.year, date.month, date.day - date.weekday % 7);
          _hoursPracticed = 0;
          int hours = 0;
          var logsList = [];

          for(DataSnapshot data in event.snapshot.children.toList()) {

            logsList.add(data.value);
            DateTime compareDate = DateTime.fromMillisecondsSinceEpoch(int.parse(data.child('date').value.toString()));
            if((compareDate.isAfter(firstDayOfWeek) || compareDate.isAtSameMomentAs(firstDayOfWeek)) && compareDate.isBefore(date)) {
              _hoursPracticed += int.parse(data.child('hours').value.toString());
            }

            if(_lastSharpenDate != -1
                && (compareDate.isAfter(DateTime.fromMillisecondsSinceEpoch(_lastSharpenDate))
                || compareDate.isAtSameMomentAs(DateTime.fromMillisecondsSinceEpoch(_lastSharpenDate)))) {
              hours += int.parse(data.child('hours').value.toString());
            }

          }
          logsList.sort((a, b) {
            return a['date'].compareTo(b['date']);
          });

          _logDate = logsList.last['date'].toString();
          _logHours = logsList.last['hours'].toString();
          _logNotes = logsList.last['notes'].toString();

          if (_lastSharpenDate != -1) {
            _hoursLeft = 30 - hours;
          }
          print(_hoursLeft.toString() + " | " + hours.toString() + " | " + _lastSharpenDate.toString());
          _progressController = false;
        });
      }
      else {
        setState(() {
          _progressController = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(150, 25, 100, 5),
                        child: Image.asset(
                            'assets/images/logo_image.png', height: 60,
                            width: 60),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: IconButton(
                          icon: _isEditMode ? Icon(Icons.done) : Icon(Icons.edit),
                          color: const Color(0xFF454545),
                          focusColor: Colors.white,
                          onPressed: () {
                            if (_isEditMode) {
                              FirebaseDatabase.instance.ref("users/" +
                                  FirebaseAuth.instance.currentUser!.uid)
                                  .update({'goal': _goalController.text})
                                  .catchError((onError) {
                                showErrorAlertDialog(
                                    context, onError.toString());
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
                    margin: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
                    decoration: BoxDecoration(
                      color: Color(0xFF98BEEB),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Weekly Practice Hour Goal: ", style: TextStyle(
                            fontSize: 12, color: Color(0xFF454545))),
                        SizedBox(
                            width: _progressController? 15 : 50,
                            height: _progressController? 15 : 100,
                            child: _progressController ?
                            CircularProgressIndicator(color: Color(0xFF454545),)
                             :
                            TextField(
                              style: TextStyle(color: Color(0xFF454545)),
                              controller: _goalController,
                              enabled: _isEditMode,
                              decoration: InputDecoration(
                                border:
                                OutlineInputBorder(
                                  borderSide: _isEditMode ? BorderSide(
                                      color: Colors.white) : BorderSide.none,
                                ),
                                filled: false,
                              ),
                            )
                        )
                      ],
                    )
                ),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
                    decoration: BoxDecoration(
                      color: Color(0xFF98BEEB),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Hours Practiced This Week  : ",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF454545))),
                          ( _progressController ?
                          SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(color: Color(0xFF454545),)
                          ) :
                          Text(_hoursPracticed.toString(),
                              style: TextStyle(color: Color(0xFF454545), fontSize: 18))
                          ),
                        ],
                      ),
                    )
                ),
                Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
                    decoration: BoxDecoration(
                      color: Color(0xFF98BEEB),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Hours Until Next Sharpening: ",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF454545))),
                              (_progressController?
                              SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(color: Color(0xFF454545),)
                              ) :
                              (_hoursLeft == 50 ? Text("-") :
                              Text(_hoursLeft <= 0 ? "TIME TO SHARPEN!" : _hoursLeft.toString(),
                                  style: TextStyle(color: Color(0xFF454545), fontSize: _hoursLeft <= 0 ? 12: 18))
                              )),
                            ],
                          ),
                    )
                ),
                SizedBox(height: 15),
                Text("Last Practice Log", style: TextStyle(fontSize: 15,
                    color: Color(0xFF454545),
                    fontWeight: FontWeight.bold)),
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
                                Text("DATE: ",
                                    style: TextStyle(fontWeight: FontWeight
                                    .bold, color: Color(0xFF454545))
                                ),
                                (_progressController ?
                                  SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(color: Color(0xFF454545),)
                                  ) :
                                  Text( _logDate == "" ? " - " :
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(_logDate.toString())
                                      ).toLocal().day.toString()
                                      + " - "
                                      + DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(_logDate.toString())
                                      ).toLocal().month.toString()
                                      + " - "
                                      + DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(
                                            _logDate.toString()
                                        )
                                      ).toLocal().year.toString(),
                                      style: TextStyle(color: Color(0xFF454545))
                                  )
                                )
                              ],
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                            child: Row(
                              children: [
                                Text("HOURS: ",
                                    style: TextStyle(fontWeight: FontWeight
                                        .bold, color: Color(0xFF454545))),

                            (_progressController ?
                                SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(color: Color(0xFF454545),)
                                ) :
                                Text( _logHours == "" ? " - " :
                                    _logHours
                                    + (_logHours == 1 ? "hr" : " hrs"),
                                    style: TextStyle(color: Color(0xFF454545)))
                                ),
                              ],
                            )
                        ),
                        Container(
                          constraints: BoxConstraints(maxHeight: 320),
                          margin: const EdgeInsets.fromLTRB(15, 8, 15, 2),
                          child: Text("NOTES:", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF454545))),
                        ),
                        Container(
                          constraints: BoxConstraints(maxHeight: 320),
                          margin: const EdgeInsets.fromLTRB(15, 2, 15, 15),
                          child: (_progressController ?
                          SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(color: Color(0xFF454545),)
                          ) :
                          Text( _logNotes == "" ? " - " : _logNotes,
                              style: TextStyle(color: Color(0xFF454545)))
                          ),
                        ),
                      ],
                    )
                ),
              ]
          )
      )
    );
  }
}
