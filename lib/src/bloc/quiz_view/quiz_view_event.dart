part of 'quiz_view_bloc.dart';

// Define Events
sealed class QuizViewEvent extends Equatable {
  const QuizViewEvent();

  @override // coverage:ignore-line
  List<Object> get props => []; // coverage:ignore-line
}

class QuizViewSelectOption extends QuizViewEvent {
  final int questionIndex;
  final String selectedOption;

  const QuizViewSelectOption({
    required this.questionIndex,
    required this.selectedOption,
  });

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex, selectedOption]; // coverage:ignore-line
}

class QuizViewSubmit extends QuizViewEvent {
  const QuizViewSubmit();
}