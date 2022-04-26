import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../alert_dialog_functions.dart';

class SharpeningLogScreen extends StatefulWidget {
  @override
  _SharpeningLogScreenState createState() => _SharpeningLogScreenState();
}

class _SharpeningLogScreenState extends State<SharpeningLogScreen> {

  bool _isEditMode = false;
  String _date = "";

  void _changeMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  void initState() {
    super.initState();


    String id = FirebaseAuth.instance.currentUser!.uid;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
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
                            if(_isEditMode) {
                              FirebaseDatabase.instance.ref("users/" + FirebaseAuth.instance.currentUser!.uid + "/sharpeningLogs/").update(
                                  {'date' : _date})
                                  .then((value)  {

                              }).catchError((error) {
                                showErrorAlertDialog(context, error.toString());
                              });
                            }
                            _changeMode();
                          },
                        ),
                      ),
                    ]
                ),
                Container(
                  height: 300,
                  width: 350,
                )
              ]
          )
      ),
    );
  }
}
