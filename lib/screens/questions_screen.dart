import 'package:flutter/material.dart';

class QuestionsScreen extends StatelessWidget {
  final String quizId;

  const QuestionsScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test soruları: '),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('burada şu testin soruları var: $quizId'),
      ),
      backgroundColor: Colors.tealAccent,
    );
  }
}
