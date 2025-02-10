class Question {
  String? correctAnswer;
  List<dynamic>? options = [];
  String? text;

  Question(Map<String, dynamic> map) {
    correctAnswer = map['correctAnswer'];
    options = map['options'];
    text = map['text'];
  }
}
