import 'package:flutter/material.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/quizzes_screen.dart';
import 'package:quiz_app/screens/user_profile_screen.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      backgroundColor: Colors.tealAccent,
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        backgroundColor: Colors.teal,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded),
            label: 'Liderlik Tablosu',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.black, size: 35),
        unselectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  int _selectedIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return QuizListScreen();
      case 1:
        return UserProfileScreen(
          userID: 'fz4WcDPuadF8TvEcQqx5',
        );
      case 2:
        return LeaderboardScreen();
      default:
        return QuizListScreen();
    }
  }
}
