import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/model/question.dart';

class Quiz {
  String? title;
  List<Question> questions = [];

  Quiz(Map<String, dynamic> map) {
    title = map['title'];
  }

  static Future<Quiz> QuizWithQuestions(String userId) async {
    DocumentSnapshot quizDoc = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(userId)
        .get();

    var map = quizDoc.data() as Map<String, dynamic>;
    Quiz quiz = Quiz(map);

    for (var ref in map['questions']) {
      if (ref is DocumentReference) {
        Question question =
            Question((await ref.get()).data() as Map<String, dynamic>);
        quiz.questions.add(question);
      }
    }

    return quiz;
  }
}
