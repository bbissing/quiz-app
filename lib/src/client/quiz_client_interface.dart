
import 'package:quiz_app/src/model/quiz_model.dart';

abstract class QuizClientInterface {
  const QuizClientInterface();
  Future<Stream<List<Quiz>>> getQuizzes();
  Future<void> createQuiz(Quiz quiz);
  Future<void> updateQuiz(Quiz quiz);
  Future<void> deleteQuiz(int id);
  Future<void> close();
}

/// Error thrown when a [Quiz] with a given id is not found.
class QuizNotFoundException implements Exception {
  const QuizNotFoundException(
      [this.message = 'Quiz not found. Please check the id and try again.']);


  final String message;
}