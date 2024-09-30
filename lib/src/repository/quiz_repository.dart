import 'package:quiz_app/src/client/local_storage_client.dart';
import 'package:quiz_app/src/model/quiz_model.dart';

class QuizRepository {
  QuizRepository({
    required LocalStorageClient quizApi,
  }) : _quizApi = quizApi;

  final LocalStorageClient _quizApi;

  Future<Stream<List<Quiz>>> getQuizzes() async {
    return _quizApi.getQuizzes();
  }

  Future<void> createQuiz(Quiz quiz) async {
    await _quizApi.createQuiz(quiz);
  }

  Future<void> updateQuiz(Quiz quiz) async {
    return _quizApi.updateQuiz(quiz);
  }

  Future<void> deleteQuiz(int id) async {
    return _quizApi.deleteQuiz(id);
  }
}