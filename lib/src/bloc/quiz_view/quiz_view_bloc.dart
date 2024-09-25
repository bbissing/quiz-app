import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';

part 'quiz_view_event.dart';
part 'quiz_view_state.dart';

class QuizViewBloc extends Bloc<QuizViewEvent, QuizViewState> {
  QuizViewBloc({
    required this.quiz,
  }) : super(QuizViewState(
          quiz: quiz,
          selectedOptions: {},
          score: 0,
          incorrectAnswers: [],
          testSubmitted: false,
        )) {
    on<QuizViewSelectOption>(_onSelectOption);
    on<QuizViewSubmit>(_onSubmit);
  }

  final Quiz quiz;

  void _onSelectOption(
    QuizViewSelectOption event,
    Emitter<QuizViewState> emit,
  ) {
    final selectedOptions = Map<int, String>.from(state.selectedOptions);
    selectedOptions[event.questionIndex] = event.selectedOption;
    emit(state.copyWith(
      selectedOptions: selectedOptions,
    ));
  }

  void _onSubmit(
    QuizViewSubmit event,
    Emitter<QuizViewState> emit,
  ) {
    int score = 0;
    List<int> incorrectAnswers = [];
    for (int i = 0; i < state.quiz.questions.length; i++) {
      final Question question = state.quiz.questions[i];
      final String selectedOption = state.selectedOptions[i] ?? '';
      if (question.correctAnswer == selectedOption) {
        score++;
      } else {
        incorrectAnswers.add(i);
      }
    }
    emit(state.copyWith(
      score: score,
      incorrectAnswers: incorrectAnswers,
      testSubmitted: true,
    ));
  }
}
