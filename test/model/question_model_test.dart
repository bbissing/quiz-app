import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/src/model/question_model.dart';

void main() {
  group('QuestionModel', () {
    final Question question = Question(
      question: 'What is the capital of France?',
      options: ['London', 'Berlin', 'Paris', 'Madrid'],
      correctAnswer: 'Paris',
    );

    test('QuestionModel', () {
      expect(question.question, 'What is the capital of France?');
      expect(question.options.length, 4);
      expect(question.options[2], 'Paris');
      expect(question.correctAnswer, 'Paris');
    });

    test('QuestionModel copyWith', () {
      final Question copiedQuestion = question.copyWith(
        question: 'What is the capital of Spain?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctAnswer: 'Madrid',
      );
      expect(copiedQuestion.question, 'What is the capital of Spain?');
      expect(copiedQuestion.options.length, 4);
      expect(copiedQuestion.options[3], 'Madrid');
      expect(copiedQuestion.correctAnswer, 'Madrid');
    });

    test('QuestionModel fromJson', () {
      final Map<String, dynamic> json = {
        'question': 'What is the capital of France?',
        'options': ['London', 'Berlin', 'Paris', 'Madrid'],
        'correctAnswer': 'Paris',
        'selectedAnswer': '',
      };
      final Question questionFromJson = Question.fromJson(json);
      expect(questionFromJson.question, 'What is the capital of France?');
      expect(questionFromJson.options.length, 4);
      expect(questionFromJson.options[2], 'Paris');
      expect(questionFromJson.correctAnswer, 'Paris');
      expect(questionFromJson.selectedAnswer, '');
    });

    test('QuestionModel toJson', () {
      final Map<String, dynamic> json = {
        'question': 'What is the capital of France?',
        'options': ['London', 'Berlin', 'Paris', 'Madrid'],
        'correctAnswer': 'Paris',
        'selectedAnswer': '',
      };
      expect(question.toJson(), json);
    });
  });
}
