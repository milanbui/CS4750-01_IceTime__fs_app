import 'package:flutter/material.dart';
import 'package:ice_time_fs_practice_log/Screens/plan_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/home_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/practice_log_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/sharpening_log_screen.dart';
import 'package:ice_time_fs_practice_log/Screens/account_screen.dart';


class BottomNavBarState extends StatefulWidget {
  @override
  _BottomNavBarStateState createState() => _BottomNavBarStateState();
}

class _BottomNavBarStateState extends State<BottomNavBarState> {

  int _selectedIndex = 2;

  static List<Widget> _widgetOptions = <Widget>[
    PlanScreen(),
    PracticeLogScreen(),
    HomeScreen(),
    SharpeningLogScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Plan\n',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Practice\n   Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard\n',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ice_skating),
            label: 'Sharpening\n     Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account\n',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xFF98BEEB),
        unselectedItemColor: Color(0xFF454545),
        selectedItemColor: Color(0xFFE5E5E5),
        onTap: _onItemTapped,
      ),
    );
  }
}
