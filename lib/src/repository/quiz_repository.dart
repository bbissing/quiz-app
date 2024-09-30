import 'package:quiz_app/src/client/local_storage_client.dart';
import 'package:quiz_app/src/client/quiz_client_interface.dart';
import 'package:quiz_app/src/model/quiz_model.dart';

class QuizRepository {
  QuizRepository({
    required LocalStorageClient quizApi,
  }) : _quizApi = quizApi;

  final LocalStorageClient _quizApi;

  Future<Stream<List<Quiz>>> getQuizzes() async {
    try {
      return _quizApi.getQuizzes();
    } catch (e) {
      throw Exception('Failed to get quizzes');
    }
  }

  Future<void> createQuiz(Quiz quiz) async {
    try {
      return _quizApi.createQuiz(quiz);
    } catch (e) {
      throw Exception('Failed to create quiz');
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    try {
      return _quizApi.updateQuiz(quiz);
    } catch (e, s) {
      Error.throwWithStackTrace(QuizNotFoundException(e.toString()), s);
    }
  }

  Future<void> deleteQuiz(int id) async {
    try {
      return _quizApi.deleteQuiz(id);
    } catch (e, s) {
      Error.throwWithStackTrace(QuizNotFoundException(e.toString()), s);
    }
  }
}
