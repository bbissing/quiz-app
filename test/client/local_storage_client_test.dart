import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/src/client/local_storage_client.dart';
import 'package:quiz_app/src/client/quiz_client_interface.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageClient', () {
    late LocalStorageClient localStorageClient;
    SharedPreferences.setMockInitialValues({});
    late SharedPreferences sharedPreferences;
    final quiz = Quiz(
      id: 0,
      title: 'Test Quiz',
      description: 'This is a test quiz',
      questions: [
        Question(
          question: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          correctAnswer: '4',
        ),
        Question(
          question: 'What is the capital of France?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctAnswer: 'Paris',
        ),
      ],
    );

    setUp(() async {
      sharedPreferences = await SharedPreferences.getInstance();
      localStorageClient = LocalStorageClient(plugin: sharedPreferences);
    });

    test('getQuizzes', () {

      expect(
          localStorageClient.getQuizzes(), isA<Future<Stream<List<Quiz>>>>());

      localStorageClient.quizStream.listen(
        expectAsync1((quizzes) {
          expect(quizzes.length, 0);
        }, count: 1),
      );
    });

    test('getQuizzes with data', () {
      final quizJson = quiz.toJson();
      String json = jsonEncode([quizJson]);
      sharedPreferences.setString(LocalStorageClient.kTodosCollectionKey, json);
      localStorageClient = LocalStorageClient(plugin: sharedPreferences);
      localStorageClient.quizStream.listen(
        expectAsync1((quizzes) {
          expect(quizzes.length, 1);
          expect(quizzes[0].id, 0);
        }, count: 1),
      );
    });

    test('createQuiz', () {
      expect(localStorageClient.createQuiz(quiz), isA<Future<void>>());
      localStorageClient.quizStream.listen(
        expectAsync1((quizzes) {
          expect(quizzes.length, 2);
          expect(quizzes[0].id, 0);
        }, count: 1),
      );
    });

    test('updateQuiz', () {
      final updatedQuiz = quiz.copyWith(title: 'Updated Quiz');
      localStorageClient.updateQuiz(updatedQuiz);
      localStorageClient.quizStream.listen(
        expectAsync1((quizzes) {
          expect(quizzes.length, 2);
          expect(quizzes[0].title, 'Updated Quiz');
        }, count: 1),
      );
    });

    test('deleteQuiz', () {
      localStorageClient.deleteQuiz(0);
      localStorageClient.quizStream.listen(
        expectAsync1((quizzes) {
          expect(quizzes.length, 1);
        }, count: 1),
      );
    });

    test('Quiz not found', () {
      expect(
        () => localStorageClient.deleteQuiz(0),
        throwsA(isA<QuizNotFoundException>()),
      );
      localStorageClient.quizStream.listen(
        expectAsync1((quizzes) {
          expect(quizzes.length, 1);
        }, count: 1),
      );
    });
  });
}
