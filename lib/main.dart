import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/home_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Widget _startScreen = SplashScreen(title: 'Flutter Demo Home Page');

    @override
    void initState() {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {

        // if user is signed in, jump to home screen
        if (user != null) {
          _startScreen = HomeScreen();
        }
        // else, load splash screen
        else {
          _startScreen = SplashScreen(title: 'Flutter Demo Home Page');
        }
      });
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'JosefinSans',
      ),
      home: _startScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
