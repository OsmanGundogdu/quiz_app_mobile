import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String userID;
  const UserProfileScreen({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('User Profile details go here'),
      ),
      backgroundColor: Colors.tealAccent,
    );
  }
}
