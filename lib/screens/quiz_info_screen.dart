import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/screens/questions_screen.dart';

class QuizInfoScreen extends StatefulWidget {
  final String quizId;

  const QuizInfoScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizInfoScreenState createState() => _QuizInfoScreenState();
}

class _QuizInfoScreenState extends State<QuizInfoScreen> {
  Quiz? quiz;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizDataWithoutQuestions();
  }

  Future<void> _fetchQuizDataWithoutQuestions() async {
    try {
      quiz = await Quiz.quizWithoutQuestions(widget.quizId);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Test bilgileri çekilirken beklenmeyen bir hata oluştu: $e");
      if (mounted) {
        setState(() {
          quiz = null;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST DETAYLARI',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : quiz == null
              ? const Center(child: Text("Test bulunamadı"))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("İsim: ${quiz?.title ?? 'Herhangi bir veri yok...'}",
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                          "Zorluk seviyesi: ${quiz?.level ?? 'Herhangi bir veri yok...'}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionsScreen(quizId: widget.quizId),
            ),
            (route) => false,
          );
        },
        child: const Icon(Icons.play_arrow, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.tealAccent,
    );
  }
}
