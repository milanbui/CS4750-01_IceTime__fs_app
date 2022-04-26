import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool _isEditMode = false;
  TextEditingController warmUpPlanController = TextEditingController();
  TextEditingController practicePlanController = TextEditingController();
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
    FirebaseDatabase.instance
        .ref("users/" + id + "/plans")
        .onValue
        .listen((DatabaseEvent event) {
      setState(() {
        List temp = [];

        for (DataSnapshot snap in event.snapshot.children.toList()) {
          temp.add(snap.value);
        }
        warmUpPlanController = TextEditingController(text: temp[0]);
        practicePlanController = TextEditingController(text: temp[1]);

        _progressController = false;
      });
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
                            child: Image.asset('assets/images/logo_image.png', height:60, width: 60),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
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

                    Text('Warm Up Plan'),
                    IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                          color: Color(0xFF98BEEB),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                                  controller: warmUpPlanController,
                                  obscureText: false,
                                  enabled: _isEditMode,
                                  minLines: null,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                    border:
                                    OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    filled: true,
                                    fillColor: _isEditMode ? Colors.white : Color(0xFF98BEEB),
                                    labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                                  ),
                                ),
                              ),
                    ),
                    SizedBox(height: 20),
                    Text('Practice Plan'),
                    IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        decoration: BoxDecoration(
                          color: Color(0xFF98BEEB),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: practicePlanController,
                          obscureText: false,
                          enabled: _isEditMode,
                          minLines: null,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            border:
                            OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            filled: true,
                            fillColor: _isEditMode ? Colors.white : Color(0xFF98BEEB),
                            labelStyle: TextStyle(fontSize: 18, color: Color(0xFF7C7C7C)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                            child: Text("Testing Resources", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF454545))),
                            onPressed: () {
                            },
                          ),
                  ]
              )
          ),
      );
  }
}

