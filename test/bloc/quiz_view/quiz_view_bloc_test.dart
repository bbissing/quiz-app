import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app/src/bloc/quiz_view/quiz_view_bloc.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';

class MockQuiz extends Mock implements Quiz {}

void main() {
  group('QuizViewBloc', () {
    late Quiz quiz;
    late List<Question> questions;

    setUp(() {
      quiz = MockQuiz();
      questions = [
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
      ];
      when(() => quiz.questions).thenReturn(questions);
    });

    blocTest<QuizViewBloc, QuizViewState>(
      'emits correct state when QuizViewSelectOption is added',
      build: () => QuizViewBloc(quiz: quiz),
      act: (bloc) => bloc.add(QuizViewSelectOption(questionIndex: 0, selectedOption: '4',)),
      expect: () => [
        QuizViewState(
          quiz: quiz,
          selectedOptions: const {0: '4'},
          score: 0,
          incorrectAnswers: const [],
          testSubmitted: false,
        ),
      ],
    );

    blocTest<QuizViewBloc, QuizViewState>(
      'emits correct state when QuizViewSubmit is added',
      build: () => QuizViewBloc(quiz: quiz),
      seed: () => QuizViewState(
        quiz: quiz,
        selectedOptions: const {0: '4', 1: 'London'},
        score: 0,
        incorrectAnswers: const [],
        testSubmitted: false,
      ),
      act: (bloc) => bloc.add(const QuizViewSubmit()),
      expect: () => [
        QuizViewState(
          quiz: quiz,
          selectedOptions: const {0: '4', 1: 'London'},
          score: 1,
          incorrectAnswers: const [1],
          testSubmitted: true,
        ),
      ],
    );
  });
}