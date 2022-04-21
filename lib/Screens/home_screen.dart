import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isEditMode = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
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
                            Text(""),
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
                            Text(""),
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 15),
                  Container(
                      height: 400,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFF98BEEB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                ]
              )
            ),
        ),
    );
  }
}
