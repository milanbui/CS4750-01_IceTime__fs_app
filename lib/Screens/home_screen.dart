import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // VARIABLES
  int _hoursPracticed = 0;    // Hours practiced this week
  int _hoursLeft = 50;        // Hours left until the next sharpening is needed
  int _lastSharpenDate = -1;  // Last day skates were sharpened
  String _logDate = "";       // Most recent practice log date
  String _logHours = "";      // Most recent practice log hours
  String _logNotes = "";      // Most recent practice log notes
  bool _progressController = true;  // Progress circle controller. wait for data to load
  bool _isEditMode = false;         // If the page is in edit mode or not
  TextEditingController _goalController = TextEditingController();  // Weekly practice hour goals

  /*****************************************************************************
   * _changeMode
   * toggles the edit mode
   ****************************************************************************/
  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  /*****************************************************************************
   * initState
   * Initializes state. Has several listeners: FirbaseDatabase listeners for
   * sharpening logs, last sharpen date, practice logs, and goals.
   ****************************************************************************/
  @override
  void initState() {
    super.initState();

    // VARIABLES
    String id = FirebaseAuth.instance.currentUser!.uid;  // current user's id
    List temp = []; // temporary list to sort sharpening logs and find the last
                    // sharpen date

    // SHARPENING LOG LISTENER
    FirebaseDatabase.instance.ref("users/" + id + "/sharpeningLogs").onValue.listen((DatabaseEvent event) {

      setState(() {
        // If no logs found, remove any existing lastSharpenDate
        if(event.snapshot.value == null) {
          FirebaseDatabase.instance.ref("users/" + id + "/lastSharpenDate").remove();
          _progressController = false;
        }
        // Else, if logs are found, sort and find last sharpen date
        else {

          // Copy logs to temp list to obtain data values
          for(DataSnapshot data in event.snapshot.children.toList()) {
            temp.add(data.value);
          }

          // Sorts in ascending order (first to last)
          temp.sort((a, b) {
            return a['date'].compareTo(b['date']);
          });

          // Updates lastSharpenDate to the last sharpen date.
          // Adds if not yet in existance
          FirebaseDatabase.instance.ref("users/" + id)
              .update({'lastSharpenDate' : temp.last['date']});

          _progressController = false;

        }
      });
    });

    // GOAL LISTENER
    FirebaseDatabase.instance .ref("users/" + id + "/goal").onValue.listen((DatabaseEvent event) {
      // If goal exists, set goal
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

    // LAST SHARPEN DATE LISTENER
    FirebaseDatabase.instance .ref("users/" + id + "/lastSharpenDate").onValue.listen((DatabaseEvent event) {

      // If last sharpen date exists
      if (event.snapshot.value != null) {

        setState(() {

          // Stores lastSharpenDate (in millisecondsSinceEpoch)
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

    // PRACTICE LOG LISTENER
    FirebaseDatabase.instance .ref("users/" + id + "/logs").onValue.listen((DatabaseEvent event) {
      // if logs exist
      if (event.snapshot.value != null) {
        setState(()  {

          // Variables
          DateTime date = DateTime.now();
          // Gets first day of current week
          DateTime firstDayOfWeek = DateTime(date.year, date.month,
                                             date.day - date.weekday % 7);
          _hoursPracticed = 0;                 // hours practice this week
          int _hoursPracticedAfterSharpen = 0; // hours practiced since last
                                               // sharpen
          var logsList = [];

          // Copies practice logs, calcs hours practiced this week, calc
          // hours practiced since last sharpen
          for(DataSnapshot data in event.snapshot.children.toList()) {

            logsList.add(data.value); // add sharpen log to temp list

            // Get current log's date to compare
            DateTime compareDate = DateTime.fromMillisecondsSinceEpoch(
                                   int.parse(data.child('date').value.toString()));

            // If current log's date is after/same day as the first day of the week
            // and is before the current date (and time), add log hours to
            // hours practiced this week
            if((compareDate.isAfter(firstDayOfWeek)
                || compareDate.isAtSameMomentAs(firstDayOfWeek))
                && compareDate.isBefore(date)) {

              _hoursPracticed += int.parse(data.child('hours').value.toString());

            }

            // If there are sharpening logs and the current date is after
            // or on the same day as the sharpening, log hours
            if(_lastSharpenDate != -1
                && (compareDate.isAfter(
                    DateTime.fromMillisecondsSinceEpoch(_lastSharpenDate))
                || compareDate.isAtSameMomentAs(
                    DateTime.fromMillisecondsSinceEpoch(_lastSharpenDate)))) {

              _hoursPracticedAfterSharpen += int.parse(data.child('hours')
                                                       .value.toString());
            }

          }

          // Sorts practice logs in ascending order
          logsList.sort((a, b) {
            return a['date'].compareTo(b['date']);
          });

          // Copies data of most recent practice log
          _logDate = logsList.last['date'].toString();
          _logHours = logsList.last['hours'].toString();
          _logNotes = logsList.last['notes'].toString();

          // If there is a practice log, save hours left
          if (_lastSharpenDate != -1) {
            // 30 hrs is the recommended # of hours to skate before sharpening
            // so 30 - hours practiced to calc how many hours before it's time
            // to sharpen again
            _hoursLeft = 30 - _hoursPracticedAfterSharpen;
          }

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
                // Row - top bar with logo and edit icon button
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Logo
                      Container(
                        margin: EdgeInsets.fromLTRB(150, 25, 100, 5),
                        child: Image.asset(
                            'assets/images/logo_image.png', height: 60,
                            width: 60),
                      ),
                      // Edit button
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 5),
                        child: IconButton(
                          icon: _isEditMode ? Icon(Icons.done) : Icon(Icons.edit),
                          color: const Color(0xFF454545),
                          focusColor: Colors.white,
                          onPressed: () {
                            // If is in edit mode, save button is clicked
                            if (_isEditMode) {

                              // Update goal
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
                // Weekly Practice Hour Goal section
                Container( // Makes the deep blue oval container
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
                    decoration: BoxDecoration(
                      color: Color(0xFF98BEEB),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row( // Contains label and data
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Weekly Practice Hour Goal: ", style: TextStyle(
                            fontSize: 12, color: Color(0xFF454545))),
                        // Changes size based on progress controller
                        SizedBox(
                            width: _progressController? 15 : 50,
                            height: _progressController? 15 : 100,
                            child:
                            _progressController ?
                            CircularProgressIndicator(color: Color(0xFF454545),) :
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
                // HOURS PRACTICED THIS WEEK SECTION
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
                // HOURS UNTIL NEXT SHARPENING SECTION
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
                // MOST RECENT PRACTICE LOG SECTION
                Text("Last Practice Log", style: TextStyle(fontSize: 15,
                    color: Color(0xFF454545),
                    fontWeight: FontWeight.bold)),
                // Holds last practice log data
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    decoration: BoxDecoration(
                      color: Color(0xFF98BEEB),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container( // Date line
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 8),
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
                        Container( // hours line
                            margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
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
                        Container( // Notes line
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
