import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/quizzes_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/user_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/profile": (BuildContext context) => UserProfileScreen(),
        "/quizlist": (BuildContext context) => QuizListScreen(),
        "/leaderboard": (BuildContext context) => LeaderboardScreen(),
        "/login": (BuildContext context) => LoginScreen(),
      },
      home: SplashScreen(),
    );
  }
}
