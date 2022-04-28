import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../alert_dialog_functions.dart';

class EditPracticeLogScreen extends StatefulWidget {
  final String d;
  EditPracticeLogScreen(this.d);
  @override
  _EditPracticeLogScreenState createState() => _EditPracticeLogScreenState();
}

class _EditPracticeLogScreenState extends State<EditPracticeLogScreen> {
  bool _isEditMode = false;

  TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _selectedNumber = 0;

  @override
  void initState() {
    super.initState();

    String id =  FirebaseAuth.instance.currentUser!.uid;
    FirebaseDatabase.instance.ref("users/" + id + "/logs/" + widget.d).onValue.listen((DatabaseEvent event) {
      setState(() {
        _selectedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(event.snapshot.child('date').value.toString()));
        _selectedNumber = int.parse(event.snapshot.child('hours').value.toString());
        _notesController = TextEditingController(text: event.snapshot.child('notes').value.toString());

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
      body: SingleChildScrollView(
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
                                      "date" : _selectedDate.millisecondsSinceEpoch,
                                      "hours" : _selectedNumber,
                                      "notes" : _notesController.text,
                                    };

                                    FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/logs/" + widget.d).update(log)
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
                                                FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/logs/" + widget.d).remove()
                                                .then((value)  {
                                                  Navigator.pop(context);
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
                        flex: 15,
                        child: Container(
                           margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                            child: Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        )
                    ),
                    Expanded(
                      flex: 26,
                      child:
                      Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                        decoration: BoxDecoration(
                          color: _isEditMode ? Colors.white : Color(0xFFC8DDFD),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(
                            _selectedDate.toLocal().day.toString() + " - "
                                + _selectedDate.toLocal().month.toString() + " - "
                                + _selectedDate.toLocal().year.toString(),
                            style: TextStyle(fontSize: 16)
                        ),
                      ),
                    ),
                    Expanded (
                      flex: 28,
                      child: Visibility(
                        visible: _isEditMode,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF799FDA),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                              fixedSize: Size(40, 35)
                            ),
                            child: Text("select date", style: TextStyle(fontSize: 15)),
                            onPressed: () async {
                              DateTime? selected = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2050),

                              );

                              if (selected != null && selected != _selectedDate) {
                                setState(() {
                                  _selectedDate = selected;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 15,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 0, 20),
                            child: Text("Hours: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        )
                    ),
                    Expanded(
                      flex: 26,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                            color: _isEditMode ? Colors.white : Color(0xFFC8DDFD),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Text(_selectedNumber.toString(), style: TextStyle(fontSize: 16)
                          ),
                        ),
                      ),
                    ),
                    Expanded (
                      flex: 28,
                      child: Visibility(
                        visible: _isEditMode,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                          child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF799FDA),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                fixedSize: Size(40, 35)
                            ),
                            child: Text("select number", style: TextStyle(fontSize: 15)),
                            onPressed: ()  {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text("Hours Practiced"),
                                      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF98BEEB), fontSize: 20),
                                      content:
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                            return NumberPicker(
                                              minValue: 0,
                                              maxValue: 24,
                                              value: _selectedNumber,
                                              onChanged: (selected) {
                                                setState(() {
                                                  _selectedNumber = selected;
                                                });
                                              },
                                            );
                                          }
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("done", style: TextStyle(color: Color(0xFF799FDA), fontSize: 18)),
                                          onPressed: () {
                                            setState(() {
                                            });
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
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 20,
                        child: Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 5, 10),
                            child: Text("Notes: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        )
                    ),
                    Expanded(
                      flex: 80,
                      child:
                      IntrinsicHeight(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 15, 10),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.top,
                            minLines: null,
                            maxLines: null,
                            expands: true,
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
                    ),
                  ],
                ),
              ]
          )
      ),
    );
  }
}
