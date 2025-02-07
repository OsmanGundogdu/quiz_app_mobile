import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      home: QuizListScreen(),
    );
  }
}

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

      // Fetching the references to questions, which are DocumentReference objects
      List<DocumentReference> questionRefs =
          List<DocumentReference>.from(quizData['questions']);
      List<Map<String, dynamic>> questions = [];

      // Fetching each question document by its reference
      for (var ref in questionRefs) {
        DocumentSnapshot questionSnapshot =
            await ref.get(); // Use the DocumentReference's `get` method
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
        title: Text("Testler"),
        backgroundColor: Colors.deepPurple,
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
                  // Navigate to the quiz questions screen (if needed)
                },
              );
            },
          );
        },
      ),
    );
  }
}
