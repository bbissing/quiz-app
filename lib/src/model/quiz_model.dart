import 'package:quiz_app/src/model/question_model.dart';

class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  final int id;
  final String title;
  final String description;
  final List<Question> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((question) => Question.fromJson(question as Map<String, dynamic>))
          .toList(),
    );
  }

  Quiz.empty() : this(id: 0, title: '', description: '', questions: [
    Question(question: 'Question 1', options: ['Option 1', 'Option 2'], correctAnswer: ''),
  ],);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  Quiz copyWith({
    int? id,
    String? title,
    String? description,
    List<Question>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
    );
  }
}