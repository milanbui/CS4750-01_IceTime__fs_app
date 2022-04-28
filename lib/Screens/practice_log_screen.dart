import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/Screens/PracticeLogScreens/add_practice_log_screen.dart';
import 'PracticeLogScreens/edit_practice_log_screen.dart';


class PracticeLogScreen extends StatefulWidget {
  @override
  _PracticeLogScreenState createState() => _PracticeLogScreenState();
}

class _PracticeLogScreenState extends State<PracticeLogScreen> {

  List _logsList =  [];
  bool _progressController = true;

  // Initializes variables based on listeners
  @override
  void initState() {
    super.initState();

    String id =  FirebaseAuth.instance.currentUser!.uid;
    List temp = [];

    // practice log listener
    FirebaseDatabase.instance.ref("users/" + id + "/logs").onValue.listen((DatabaseEvent event) {
      setState(() {
        _logsList = [];

        // add list to logs list
        for(DataSnapshot data in event.snapshot.children.toList()) {
          _logsList.add(data.value);
        }

        // sorts in ascending order
        _logsList.sort((a, b) {
            return a['date'].compareTo(b['date']);
        });

        _progressController = false;
      });
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
                Row( // top bar with logo and add button
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
                            // navigates to add practice screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddPracticeLogScreen()));
                          },
                        ),
                      ),
                    ]
                ),
                Expanded( // LIST SECTIONS
                  flex: 80,
                  child: _progressController ?
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 290, 10, 290),
                      child: CircularProgressIndicator(color: Color(0xFF454545))
                  ) :
                  ListView.builder( // list of practice logs
                    itemCount: _logsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell( // makes container clickable
                          onTap: () {
                            // navigates to edit page when container/log clicked
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    EditPracticeLogScreen(
                                        _logsList[index]['timeStamp'].toString())));
                          },
                          child: Container(  // creates deep blue container to hold log
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFF98BEEB),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // displays date in local time zone in format
                              // day - month - year
                              Container(
                                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                  child: Text(
                                      "DATE: "
                                      + DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                              _logsList[index]['date'].toString()
                                          )
                                      ).toLocal().day.toString()
                                      + " - "
                                      + DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                              _logsList[index]['date'].toString()
                                          )
                                      ).toLocal().month.toString()
                                      + " - "
                                      + DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                              _logsList[index]['date'].toString()
                                          )
                                      ).toLocal().year.toString()
                                  )
                              ),
                              // Hours
                              Container(
                                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Text(
                                      "HOURS: " + _logsList[index]['hours'].toString() + (_logsList[index]['hours'] == 1 ? "hr" : " hrs")
                                  )
                              ),
                              // notes
                              Container(
                                  constraints: BoxConstraints(maxHeight: 55),
                                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                                  child: Text("NOTES:\n" + _logsList[index]['notes'].toString())
                              ),

                            ],
                          )
                        )
                      );
                    },

                  ),
                )
              ]
          )
      ),
    );
  }
}
