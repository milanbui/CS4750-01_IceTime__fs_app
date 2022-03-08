import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // functions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Image.asset('assets/images/splash_icon.png', height:200, width: 200),
              SizedBox(height: 250),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Color(0xFF7C7C7C),
                  onSurface: Colors.red,
                ),
                child: Text("Log In", style: TextStyle(fontSize: 23)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),

            ],
          )
      ),
    );
  }
}
