import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';

void main() {
  group('QuizModel', () {
    final Quiz quiz = Quiz(
      id: 1,
      title: 'Geography Quiz',
      description: 'Test your knowledge of the world!',
      questions: [
        Question(
          question: 'What is the capital of France?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctAnswer: 'Paris',
        ),
        Question(
          question: 'What is the capital of Spain?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctAnswer: 'Madrid',
        ),
      ],
    );
    test('QuizModel', () {
      expect(quiz.id, 1);
      expect(quiz.title, 'Geography Quiz');
      expect(quiz.description, 'Test your knowledge of the world!');
      expect(quiz.questions.length, 2);
      expect(quiz.questions[0].question, 'What is the capital of France?');
      expect(quiz.questions[0].options.length, 4);
      expect(quiz.questions[0].options[2], 'Paris');
      expect(quiz.questions[0].correctAnswer, 'Paris');
      expect(quiz.questions[1].question, 'What is the capital of Spain?');
      expect(quiz.questions[1].options.length, 4);
      expect(quiz.questions[1].options[3], 'Madrid');
      expect(quiz.questions[1].correctAnswer, 'Madrid');
    });

    test('QuizModel empty', () {
      final Quiz emptyQuiz = Quiz.empty();
      expect(emptyQuiz.id, 0);
      expect(emptyQuiz.title, '');
      expect(emptyQuiz.description, '');
      expect(emptyQuiz.questions.length, 1);
      expect(emptyQuiz.questions[0].question, '');
      expect(emptyQuiz.questions[0].options.length, 2);
      expect(emptyQuiz.questions[0].options[0], '');
      expect(emptyQuiz.questions[0].options[1], '');
      expect(emptyQuiz.questions[0].correctAnswer, '');
    });

    test('QuizModel copyWith', () {
      final Quiz copiedQuiz = quiz.copyWith(
        id: 2,
        title: 'History Quiz',
        description: 'Test your',
        questions: [
          Question(
            question: 'What year was the Declaration of Independence signed?',
            options: ['1776', '1789', '1800', '1812'],
            correctAnswer: '1776',
          ),
          Question(
            question: 'What year did World War II end?',
            options: ['1945', '1950', '1960', '1970'],
            correctAnswer: '1945',
          ),
        ],
      );

      expect(copiedQuiz.id, 2);
      expect(copiedQuiz.title, 'History Quiz');
      expect(copiedQuiz.description, 'Test your');
      expect(copiedQuiz.questions.length, 2);
      expect(copiedQuiz.questions[0].question,
          'What year was the Declaration of Independence signed?');
      expect(copiedQuiz.questions[0].options.length, 4);
      expect(copiedQuiz.questions[0].options[0], '1776');
      expect(copiedQuiz.questions[0].correctAnswer, '1776');
      expect(
          copiedQuiz.questions[1].question, 'What year did World War II end?');
      expect(copiedQuiz.questions[1].options.length, 4);
      expect(copiedQuiz.questions[1].options[0], '1945');
      expect(copiedQuiz.questions[1].correctAnswer, '1945');
    });

    test('QuizModel fromJson', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'title': 'Geography Quiz',
        'description': 'Test your knowledge of the world!',
        'questions': [
          {
            'question': 'What is the capital of France?',
            'options': ['London', 'Berlin', 'Paris', 'Madrid'],
            'correctAnswer': 'Paris',
          },
          {
            'question': 'What is the capital of Spain?',
            'options': ['London', 'Berlin', 'Paris', 'Madrid'],
            'correctAnswer': 'Madrid',
          },
        ],
      };

      final Quiz fromJsonQuiz = Quiz.fromJson(json);

      expect(fromJsonQuiz.id, 1);
      expect(fromJsonQuiz.title, 'Geography Quiz');
      expect(fromJsonQuiz.description, 'Test your knowledge of the world!');
      expect(fromJsonQuiz.questions.length, 2);
      expect(fromJsonQuiz.questions[0].question, 'What is the capital of France?');
      expect(fromJsonQuiz.questions[0].options.length, 4);
      expect(fromJsonQuiz.questions[0].options[2], 'Paris');
      expect(fromJsonQuiz.questions[0].correctAnswer, 'Paris');
      expect(fromJsonQuiz.questions[1].question, 'What is the capital of Spain?');
      expect(fromJsonQuiz.questions[1].options.length, 4);
      expect(fromJsonQuiz.questions[1].options[3], 'Madrid');
      expect(fromJsonQuiz.questions[1].correctAnswer, 'Madrid');
    });

    test('QuizModel toJson', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'title': 'Geography Quiz',
        'description': 'Test your knowledge of the world!',
        'questions': [
          {
            'question': 'What is the capital of France?',
            'options': ['London', 'Berlin', 'Paris', 'Madrid'],
            'correctAnswer': 'Paris',
            'selectedAnswer': '',
          },
          {
            'question': 'What is the capital of Spain?',
            'options': ['London', 'Berlin', 'Paris', 'Madrid'],
            'correctAnswer': 'Madrid',
            'selectedAnswer': '',
          },
        ],
      };

      expect(quiz.toJson(), json);
    });
  });
}
