import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/logo_image.png', height:60, width: 60),
              Container(
                height: 300,
                width: 350,
                decoration: BoxDecoration(
                  color: Color(0xFF98BEEB),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child:
                  SfCalendar(
                    view: CalendarView.month,
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
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  color: Color(0xFF98BEEB),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ]
          )
        ),
    );
  }
}
