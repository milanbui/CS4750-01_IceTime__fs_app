import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ice_time_fs_practice_log/Screens/SharpeningLogScreens/add_sharpening_log_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/SharpeningLogScreens/edit_sharpening_log_screen.dart';

class SharpeningLogScreen extends StatefulWidget {
  @override
  _SharpeningLogScreenState createState() => _SharpeningLogScreenState();
}

class _SharpeningLogScreenState extends State<SharpeningLogScreen> {

  List _logsList =  [];
  bool _progressController = true;

  @override
  void initState() {
    super.initState();

    String id =  FirebaseAuth.instance.currentUser!.uid;
    // SHARPENING LOG LISTENER
    FirebaseDatabase.instance.ref("users/" + id + "/sharpeningLogs").onValue.listen((DatabaseEvent event) {
      setState(() {
        _logsList = [];
        // IF logs dont exist, delete last sharpen date
        if(event.snapshot.value == null) {
          FirebaseDatabase.instance.ref("users/" + id + "/lastSharpenDate").remove();
          _progressController = false;
        }
        // If logs exist
        else {

          // Adds logs to local list
          for(DataSnapshot data in event.snapshot.children.toList()) {
            _logsList.add(data.value);
          }

          // sorts  in ascending order by date
          _logsList.sort((a, b) {
            return a['date'].compareTo(b['date']);
          });

          // saves last sharpen date
          FirebaseDatabase.instance.ref("users/" + id).update({'lastSharpenDate' : _logsList.last['date']});


          _progressController = false;

        }
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
               // Top bar: logo and add button
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddSharpeningLogScreen()));
                          },
                        ),
                      ),
                    ]
                ),
                Expanded(
                  flex: 80,
                  child: _progressController ?
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 290, 10, 290),
                      child: CircularProgressIndicator(color: Color(0xFF454545))
                  ) :
                  ListView.builder(
                    itemCount: _logsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditSharpeningLogScreen(_logsList[index]['timeStamp'].toString())));
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: const BoxDecoration(
                                color: Color(0xFF98BEEB),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                          child: Text("Notes: " + (_logsList[index]['notes'] == null ? "No Notes" : _logsList[index]['notes'].toString()))
                                      ),
                                    ],
                                  ),
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
