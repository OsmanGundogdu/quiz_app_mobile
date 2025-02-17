import 'package:flutter/material.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/quizzes_screen.dart';
import 'package:quiz_app/screens/user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Widget>(
        future: _getPage(_selectedIndex),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            return snapshot.data ??
                Center(child: Text('Herhangi bir veri yok'));
          }
        },
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded),
            label: 'Liderlik Tablosu',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 88, 88, 88),
        unselectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(
            color: const Color.fromARGB(255, 88, 88, 88), size: 35),
        unselectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  int _selectedIndex = 0;

  Future<Widget> _getPage(int index) async {
    switch (index) {
      case 0:
        return UserProfileScreen();
      case 1:
        final prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString("userId");
        if (userId != null) {
          return QuizListScreen();
        } else {
          return Center(child: Text('İlgili kullanıcı bulunamadı'));
        }
      case 2:
        return LeaderboardScreen();
      default:
        return QuizListScreen();
    }
  }
}
