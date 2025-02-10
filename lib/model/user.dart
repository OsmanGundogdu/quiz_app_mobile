import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/model/quiz.dart';

class User {
  String? email;
  String? firstName;
  String? lastName;
  int? totalScore;
  List<Quiz> quizzes = [];

  User(Map<String, dynamic> map) {
    email = map["email"];
    firstName = map["firstname"];
    lastName = map["lastname"];
    totalScore = map["totalScore"];
  }

  static Future<User> userProfile(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    var map = userDoc.data() as Map<String, dynamic>;
    User user = User(map);

    for (var ref in map['quizzesTaken']) {
      if (ref is DocumentReference) {
        Quiz quiz = Quiz((await ref.get()).data() as Map<String, dynamic>);
        user.quizzes.add(quiz);
      }
    }

    return user;
  }
}
