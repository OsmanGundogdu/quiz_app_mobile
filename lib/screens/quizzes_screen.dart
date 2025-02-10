import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/quiz_info_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchQuizzes() async {
    QuerySnapshot quizSnapshot = await _firestore.collection('quizzes').get();
    List<Map<String, dynamic>> quizzes = [];

    for (var quizDoc in quizSnapshot.docs) {
      Map<String, dynamic> quizData = quizDoc.data() as Map<String, dynamic>;
      quizData['id'] = quizDoc.id;

      List<DocumentReference> questionRefs =
          List<DocumentReference>.from(quizData['questions']);
      List<Map<String, dynamic>> questions = [];

      for (var ref in questionRefs) {
        DocumentSnapshot questionSnapshot = await ref.get();
        Map<String, dynamic> questionData =
            questionSnapshot.data() as Map<String, dynamic>;
        questions.add(questionData);
      }

      quizData['questions'] = questions;
      quizzes.add(quizData);
    }

    return quizzes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TESTLER"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Herhangi bir test bulunamadı."));
          }

          List<Map<String, dynamic>> quizzes = snapshot.data!;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              var quiz = quizzes[index];
              return ListTile(
                title: Text(quiz['title']),
                subtitle: Text("${quiz['questions'].length} Soru"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizInfoScreen(quizId: quiz['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      backgroundColor: Colors.tealAccent,
    );
  }
}
