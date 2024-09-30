class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String selectedAnswer;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.selectedAnswer = '',
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).map((option) => option as String).toList(),
      correctAnswer: json['correctAnswer'] as String,
      selectedAnswer: json['selectedAnswer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'selectedAnswer': selectedAnswer,
    };
  }

  Question copyWith({
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? selectedAnswer
  }) {
    return Question(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }
}