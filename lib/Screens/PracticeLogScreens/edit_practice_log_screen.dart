import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../alert_dialog_functions.dart';

class EditPracticeLogScreen extends StatefulWidget {
  final String d;
  EditPracticeLogScreen(this.d);
  @override
  _EditPracticeLogScreenState createState() => _EditPracticeLogScreenState();
}

class _EditPracticeLogScreenState extends State<EditPracticeLogScreen> {
  bool _isEditMode = false;
  bool _progressController = true;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    String id =  FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref("users/" + id + "/logs/" + widget.d).onValue.listen((DatabaseEvent event) {
      setState(() {
        List temp = [];

        for(DataSnapshot snap in event.snapshot.children.toList()) {
          temp.add(snap.value);
        }
        _dateController = TextEditingController(text: temp[0]);
        _hoursController = TextEditingController(text: temp[1]);
        _notesController = TextEditingController(text: temp[2]);

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
                      Expanded(
                        flex: 75,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 20, _isEditMode? 300 : 250, 0),
                          child: IconButton(
                              icon:  Icon(Icons.arrow_back),
                              color:  Color(0xFF454545),
                              focusColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              }
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: IconButton(
                                icon: _isEditMode ?  Icon(Icons.done) :  Icon(Icons.edit),
                                color:  Color(0xFF454545),
                                focusColor: Colors.white,
                                onPressed: () {
                                  if(_isEditMode) {
                                    var log = {
                                      "date" : _dateController.text,
                                      "hours" : _hoursController.text,
                                      "notes" : _notesController.text,
                                    };

                                    FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/logs/" + log['date'].toString()).set(log)
                                        .then((value)  {

                                    }).catchError((error) {
                                      showErrorAlertDialog(context, error.toString());
                                    });
                                  }
                                  _changeMode();
                                },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: _isEditMode ? 0 : 15,
                        child: Visibility(
                          visible: !_isEditMode,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color:  Colors.red,
                              focusColor: Colors.white,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text("Delete?"),
                                          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF98BEEB), fontSize: 20),
                                          content: Text("Delete cannot be undone."),
                                          actions: [
                                            TextButton(
                                              child: Text("delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                                              onPressed: () {
                                                FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/logs/" + _dateController.text).remove()
                                                .then((value)  {
                                                  Navigator.pop(context);
                                                }).catchError((error) {
                                                  showErrorAlertDialog(context, error.toString());
                                                });
                                               },
                                            ),
                                            TextButton(
                                              child: Text("cancel", style: TextStyle(color: Color(0xFF799FDA), fontSize: 18)),
                                              onPressed: () {
                                                  Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                          backgroundColor: Color(0xFFE5E5E5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                          )
                                      );
                                    },
                                  );

                              },
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 20,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 5, 10),
                            child: Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        )
                    ),
                    Expanded(
                      flex: 80,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 15, 10),
                        child: TextField(
                          controller: _dateController,
                          obscureText: false,
                          enabled: _isEditMode,
                          decoration: InputDecoration(
                            border:
                            OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            filled: true,
                            fillColor: _isEditMode ? Colors.white : Color(0xFFC8DDFD),
                            labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 20,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 5, 10),
                            child: Text("Hours: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        )
                    ),
                    Expanded(
                      flex: 80,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 15, 10),
                        child: TextField(
                          controller: _hoursController,
                          obscureText: false,
                          enabled: _isEditMode,
                          decoration: InputDecoration(
                            border:
                            OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            filled: true,
                            fillColor: _isEditMode ? Colors.white : Color(0xFFC8DDFD),
                            labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 20,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 5, 10),
                            child: Text("Notes: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        )
                    ),
                    Expanded(
                      flex: 80,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 15, 10),
                        child: TextField(
                          maxLines: (MediaQuery.of(context).viewInsets.bottom == 0) ? 30 : 15,
                          controller: _notesController,
                          obscureText: false,
                          enabled: _isEditMode,
                          decoration: InputDecoration(
                            border:
                            OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            filled: true,
                            fillColor: _isEditMode ? Colors.white : Color(0xFFC8DDFD),
                            labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
          )
      ),
    );
  }
}
