import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/_layout.dart';
import 'package:quiz_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int splashTime = 0;
  String loadingText = "Loading.";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        splashTime += 100;
        if (splashTime < 1000) {
          loadingText = "Loading.";
        } else if (splashTime >= 1000 && splashTime < 2000) {
          loadingText = "Loading..";
        } else if (splashTime >= 2000) {
          loadingText = "Loading...";
        }
      });

      if (splashTime >= 2100) {
        timer?.cancel();
        _checkUserLoginStatus();
      }
    });
  }

  Future<void> _checkUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId != null && userId.isNotEmpty) {
      _navigateTo(Layout());
    } else {
      _navigateTo(const LoginScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 100.0,
              height: 100.0,
            ),
            const SizedBox(height: 20),
            Text(
              loadingText,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
