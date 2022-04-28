import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DDFD),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset('assets/images/splash_icon.png', height: 400, width: 400),
              SizedBox(height: 150),
              // Button leads to log in screen when pressed
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
