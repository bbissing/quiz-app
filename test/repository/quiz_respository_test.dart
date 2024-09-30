import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/src/client/local_storage_client.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('QuizRepository', () {
    SharedPreferences.setMockInitialValues({});
    late SharedPreferences sharedPreferences;
    late LocalStorageClient localStorageClient;
    late QuizRepository quizRepository;

    setUp(() async {
      sharedPreferences = await SharedPreferences.getInstance();
      localStorageClient = LocalStorageClient(plugin: sharedPreferences);
      quizRepository = QuizRepository(quizApi: localStorageClient);
    });

    test('QuizRepository getQuizzes', () {
      expect(quizRepository.getQuizzes(), isA<Future<Stream<List<Quiz>>>>());
    });

    test('QuizRepository createQuiz', () {
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
      expect(quizRepository.createQuiz(quiz), isA<Future<void>>());
    });

    // test('QuizRepository updateQuiz', () {
    //   final Quiz quiz = Quiz(
    //     id: 1,
    //     title: 'Geography Quiz',
    //     description: 'Test your knowledge of the world!',
    //     questions: [
    //       Question(
    //         question: 'What is the capital of France?',
    //         options: ['London', 'Berlin', 'Paris', 'Madrid'],
    //         correctAnswer: 'Paris',
    //       ),
    //       Question(
    //         question: 'What is the capital of Spain?',
    //         options: ['London', 'Berlin', 'Paris', 'Madrid'],
    //         correctAnswer: 'Madrid',
    //       ),
    //     ],
    //   );
    //   when(() => localStorageClient.updateQuiz(quiz)).thenAnswer((_) async {});
    //   expect(quizRepository.updateQuiz(quiz), isA<void>());
    // });

    // test('QuizRepository deleteQuiz', () {
    //   expect(quizRepository.deleteQuiz(1), isA<bool>());
    // });
  });
}
