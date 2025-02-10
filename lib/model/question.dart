import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String? correctAnswer;
  List<String>? options = [];
  String? text;

  Question(Map<String, dynamic> map) {
    correctAnswer = map['correctAnswer'];
    options = map['options'];
    text = map['text'];
  }
}
