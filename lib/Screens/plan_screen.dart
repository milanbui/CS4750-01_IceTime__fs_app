import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
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
      body: Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: _isEditMode ? Icon(Icons.done) : Icon(Icons.edit),
                            color: Color(0xFF454545),
                            focusColor: Colors.white,
                            onPressed: () {
                              _changeMode();
                            },
                          ),
                      ]
                      ),
                    ),
                    Container(
                      height: 250,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFF98BEEB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 250,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color(0xFF98BEEB),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            child: Text("Testing Resources", style: TextStyle(fontSize: 15, color: Color(0xFF454545))),
                            onPressed: () {
                        //      Navigator.push(
                          //      context,
                            //    MaterialPageRoute(builder: (context) => BottomNavBarState()),
                             // );
                            },
                          ),
                          Text(" | ", style: TextStyle(color: Color(0xFF454545))),
                          TextButton(
                            child: Text("Testing Resources", style: TextStyle(fontSize: 15, color: Color(0xFF454545))),
                            onPressed: () {
                              //      Navigator.push(
                              //      context,
                              //    MaterialPageRoute(builder: (context) => BottomNavBarState()),
                              // );
                            },
                          ),

                        ],
                      )
                    )
                  ]
              )
          ),
      ),
    );
  }


}
