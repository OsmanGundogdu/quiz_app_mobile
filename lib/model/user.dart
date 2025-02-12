import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz.dart';

class User {
  String? userID;
  String? email;
  String? firstName;
  String? lastName;
  int? totalScore;
  String? password;
  List<Quiz> quizzes = [];

  User(Map<String, dynamic> map, String? id) {
    userID = id;
    email = map["email"];
    firstName = map["firstname"];
    lastName = map["lastname"];
    totalScore = map["totalScore"];
    password = map["password"];
  }

  static Future<User> userProfile(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception("Kullanıcı bulunamadı.");
    }

    var map = userDoc.data() as Map<String, dynamic>;
    User user = User(map, userDoc.id);

    if (map.containsKey('quizzesTaken')) {
      for (var ref in map['quizzesTaken']) {
        if (ref is DocumentReference) {
          Quiz quiz = Quiz((await ref.get()).data() as Map<String, dynamic>);
          user.quizzes.add(quiz);
        }
      }
    }

    return user;
  }

  static Future<User?> userLogin(
      BuildContext context, String email, String password) async {
    DocumentSnapshot? userDoc = //
        (await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: email)
                .get())
            .docs
            .firstOrNull;

    if (userDoc == null) {
      _showErrorDialog(
          context, "Email veya Şifre yanlış. Lütfen tekrar deneyin.");
      return null;
    }

    var map = userDoc.data() as Map<String, dynamic>;
    User user = User(map, userDoc.id);

    if (user.password != password) {
      _showErrorDialog(
          context, "Email veya Şifre yanlış. Lütfen tekrar deneyin.");
      return null;
    }

    //localStorage.setItem("userId", user.userID);

    return user;
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hata"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}
