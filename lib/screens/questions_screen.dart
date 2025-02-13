import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz.dart';
import 'package:quiz_app/model/user.dart';
import 'package:quiz_app/screens/_layout.dart';

class QuestionsScreen extends StatefulWidget {
  final String quizId;

  const QuestionsScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  Quiz? quiz;
  int currentQuestionIndex = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> questions = [];
  Map<int, String> selectedOptionsMap = {};
  int dogruCevapSayisi = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      quiz = await Quiz.quizWithQuestions(widget.quizId);
      setState(() {
        questions = quiz?.questions
                .map((q) => {
                      "text": q.text,
                      "options": q.options,
                      "correctAnswer": q.correctAnswer
                    })
                .toList() ??
            [];
        isLoading = false;
      });
    } catch (e) {
      print("Sorular çekilirken beklenmeyen bir hata oluştu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _showCompletionDialog() {
    User? user;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Test Tamamlandı!"),
        content: Text(
            "Tebrikler, testi tamamladınız. Toplam doğru sayınız: $dogruCevapSayisi"),
        actions: [
          TextButton(
            onPressed: () {
              // first pop for closing the dialog
              Navigator.pop(context);
              // second pop for go back to the main screen
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Layout(),
                ),
              );
              setState(() {
                user!.totalScore = user.totalScore! + dogruCevapSayisi * 5;
                user.quizzes.add(quiz!);
              });
            },
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.tealAccent,
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Sorular",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: Text(
            "Bu teste ait soru bulunamadı!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.tealAccent,
      );
    }

    final question = questions[currentQuestionIndex];
    final selectedOption = selectedOptionsMap[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Soru ${currentQuestionIndex + 1} / ${questions.length}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question["text"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: question["options"].map<Widget>((option) {
                return Card(
                  color: selectedOption == option ? Colors.green : Colors.white,
                  child: ListTile(
                    title: Text(option),
                    onTap: () {
                      setState(() {
                        selectedOptionsMap[currentQuestionIndex] = option;
                        if (option == question["correctAnswer"]) {
                          dogruCevapSayisi++;
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.tealAccent,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: currentQuestionIndex > 0
                ? FloatingActionButton(
                    onPressed: previousQuestion,
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  )
                : const SizedBox(),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 32),
              child: currentQuestionIndex == questions.length - 1
                  ? ElevatedButton(
                      onPressed: _showCompletionDialog,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          fixedSize: Size(160, 50)),
                      child: Text(
                        "TESTİ BİTİR",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ))
                  : FloatingActionButton(
                      onPressed: nextQuestion,
                      backgroundColor: Colors.black,
                      child:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                    )),
        ],
      ),
    );
  }
}
