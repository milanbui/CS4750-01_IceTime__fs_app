import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../alert_dialog_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {

  bool _isEditMode = false;
  TextEditingController warmUpPlanController = TextEditingController(text: "");
  TextEditingController practicePlanController = TextEditingController(text: "");

  // toggles edit mode using edit icon
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

    String id = FirebaseAuth.instance.currentUser!.uid; // current user id

    // Practice plan listener
    FirebaseDatabase.instance.ref("users/" + id + "/plans").onValue
        .listen((DatabaseEvent event) {
      // if plans exist, load
      if (event.snapshot.exists) {
        setState(() {
          warmUpPlanController = TextEditingController(
              text: event.snapshot.child('warmUpPlan').value.toString());

          practicePlanController = TextEditingController(
              text: event.snapshot.child('practicePlan').value.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // url to us figure skating rulebook
    var _url = Uri.parse('https://online.flippingbook.com/view/375134/');

    // launches url
    void _launchUrl() async {
      if (!await launchUrl(_url)) throw 'Could not launch $_url';
    }

    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // top bar with logo and edit button
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(150, 25, 100, 5),
                            child: Image.asset('assets/images/logo_image.png', height:60, width: 60),
                          ),
                          Container( // edit button
                            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            child: IconButton(
                              icon: _isEditMode ? Icon(Icons.done) : Icon(Icons.edit),
                              color: Color(0xFF454545),
                              focusColor: Colors.white,
                              onPressed: () {

                                // saves plans if toggling out of edit mode
                                if(_isEditMode) {
                                  var plans = {
                                    'warmUpPlan' : warmUpPlanController.text,
                                    'practicePlan' : practicePlanController.text
                                  };
                                  FirebaseDatabase.instance.ref("users/"
                                      + FirebaseAuth.instance.currentUser!.uid
                                      + "/plans/").update(plans)
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
                    SizedBox(height: 15),
                    Text('Warm Up Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IntrinsicHeight( // conatiner height matched text field height
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
                    Text('Practice Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IntrinsicHeight(  // so container height matches text field height
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
                          minLines: null,  // allows for expanding
                          maxLines: null,  // allows for expanding
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
                            onPressed: _launchUrl,
                          ),
                  ]
              )
          ),
      );
  }
}

