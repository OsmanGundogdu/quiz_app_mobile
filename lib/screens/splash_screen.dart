import 'package:flutter/material.dart';
//import 'package:localstorage/localstorage.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:quiz_app/screens/quizzes_screen.dart';
import 'package:quiz_app/screens/user_profile_screen.dart';

class SplashScreen extends StatefulWidget {
  // check if there is a user in localstorage
  // if user logged in successfully, navigate to the QuizListScreen
  // if user not logged in, navigate to the LoginScreen

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    //String? userId = localStorage.getItem("userId");

    // if (userId != null && userId.isNotEmpty) {
    //_navigateTo(const UserProfileScreen(userID: ,));
    // } else {
    _navigateTo(const LoginScreen());
    // }
  }

  void _navigateTo(Widget screen) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
