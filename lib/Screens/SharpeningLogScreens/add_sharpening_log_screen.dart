import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';
class AddSharpeningLogScreen extends StatefulWidget {
  @override
  _AddSharpeningLogScreenState createState() => _AddSharpeningLogScreenState();
}

class _AddSharpeningLogScreenState extends State<AddSharpeningLogScreen> {

  TextEditingController dateController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Color(0xFF454545),
                  iconSize: 35,
                  focusColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 325, 0),
                ),
                SizedBox(height: 50),
                Text("Add Sharpening Log", style: TextStyle(color: Color(0xFF799FDA), fontWeight: FontWeight.bold, fontSize: 25)),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: dateController,
                        obscureText: false,
                        enabled: true,
                        decoration: InputDecoration(
                          border:
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'date',
                          labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                        ),
                      ),
                      SizedBox(height: 10),
                      IntrinsicHeight(
                        child: Container(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.top,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            controller: notesController,
                            obscureText: false,
                            enabled: true,
                            decoration: InputDecoration(
                              border:
                              OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'notes',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF799FDA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    minimumSize: Size(150, 35),
                  ),
                  child: Text("done", style: TextStyle(fontSize: 18)),
                  onPressed: () async {
                    var log = {
                      "date" : dateController.text,
                      "notes" : notesController.text,
                    };

                    FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/sharpeningLogs/" + log['date'].toString()).set(log)
                         .then((value)  {
                          Navigator.pop(context);

                        }).catchError((error) {
                          showErrorAlertDialog(context, error.toString());
                        });
                  },
                ),
              ]
          )
      ),
    );
  }
}

