import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ice_time_fs_practice_log/alert_dialog_functions.dart';
class AddSharpeningLogScreen extends StatefulWidget {
  @override
  _AddSharpeningLogScreenState createState() => _AddSharpeningLogScreenState();
}

class _AddSharpeningLogScreenState extends State<AddSharpeningLogScreen> {

  TextEditingController hoursController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  DateTime _selectedDate = DateTime.now();

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 140,
                      padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                      margin: const EdgeInsets.fromLTRB(25, 0, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Text(
                          _selectedDate.toLocal().day.toString() + " - "
                              + _selectedDate.toLocal().month.toString() + " - "
                              + _selectedDate.toLocal().year.toString(),
                          style: TextStyle(fontSize: 16)
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF799FDA),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        fixedSize: Size(190, 35),
                      ),
                      child: Text("select date", style: TextStyle(fontSize: 18)),
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
                  ],
                ),
                SizedBox(height: 10),
                IntrinsicHeight(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                      "timeStamp" : DateTime.now().millisecondsSinceEpoch.toString(),
                      "date" : _selectedDate.millisecondsSinceEpoch,
                      "notes" : notesController.text,
                    };

                    FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/sharpeningLogs/" + log['timeStamp'].toString()).set(log)
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

