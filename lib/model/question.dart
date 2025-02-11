class Question {
  String? correctAnswer;
  List<String> options = [];
  String? text;

  Question(Map<String, dynamic> map) {
    correctAnswer = map['correctAnswer'];
    options = (map['options'] as List).map((a) => a.toString()).toList();
    text = map['text'];
  }
}
