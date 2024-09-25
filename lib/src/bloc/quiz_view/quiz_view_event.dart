part of 'quiz_view_bloc.dart';

// Define Events
sealed class QuizViewEvent extends Equatable {
  const QuizViewEvent();

  @override
  List<Object> get props => [];
}

class QuizViewSelectOption extends QuizViewEvent {
  final int questionIndex;
  final String selectedOption;
  final Question question;

  const QuizViewSelectOption({
    required this.questionIndex,
    required this.selectedOption,
    required this.question
  });

  @override
  List<Object> get props => [questionIndex, selectedOption, question];
}

class QuizViewSubmit extends QuizViewEvent {
  const QuizViewSubmit();
}