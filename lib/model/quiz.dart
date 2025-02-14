import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/model/question.dart';

class Quiz {
  String? title;
  List<Question> questions = [];
  String? level;

  Quiz(Map<String, dynamic> map) {
    title = map['title'];
    level = map['level'];
  }

  static Future<Quiz> quizWithQuestions(String quizId) async {
    DocumentSnapshot quizDoc = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
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

  static quizWithoutQuestions(String quizId) {
    return FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .get()
        .then((quizDoc) {
      var map = quizDoc.data() as Map<String, dynamic>;
      return Quiz(map);
    });
  }
}
