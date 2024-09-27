part of 'edit_quiz_view_bloc.dart';

sealed class EditQuizViewEvent extends Equatable {
  const EditQuizViewEvent();

  @override // coverage:ignore-line
  List<Object> get props => []; // coverage:ignore-line
}

class EditQuizSubmitted extends EditQuizViewEvent {
  const EditQuizSubmitted();

  @override // coverage:ignore-line
  List<Object> get props => []; // coverage:ignore-line
}

class EditQuizDelete extends EditQuizViewEvent {
  const EditQuizDelete();
}

class EditQuizTitleChanged extends EditQuizViewEvent {
  const EditQuizTitleChanged(this.title);

  final String title;

  @override // coverage:ignore-line
  List<Object> get props => [title]; // coverage:ignore-line
}

class EditQuizDescriptionChanged extends EditQuizViewEvent {
  const EditQuizDescriptionChanged(this.description);
  final String description;

  @override // coverage:ignore-line
  List<Object> get props => [description]; // coverage:ignore-line
}

class EditQuizAddQuestion extends EditQuizViewEvent {
  const EditQuizAddQuestion();

  @override // coverage:ignore-line
  List<Object> get props => []; // coverage:ignore-line
}

class EdditQuizCorrectAnswerChanged extends EditQuizViewEvent {
  const EdditQuizCorrectAnswerChanged(
      {required this.questionIndex, required this.correctAnswer});

  final int questionIndex;
  final String correctAnswer;

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex, correctAnswer]; // coverage:ignore-line
}

class EditQuizQuestionChanged extends EditQuizViewEvent {
  const EditQuizQuestionChanged(
      {required this.questionIndex, required this.questionHeader});

  final int questionIndex;
  final String questionHeader;

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex, questionHeader]; // coverage:ignore-line
}

class EditQuizDeleteQuestion extends EditQuizViewEvent {
  const EditQuizDeleteQuestion({required this.questionIndex});

  final int questionIndex;

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex]; // coverage:ignore-line
}

class EditQuizAddQuestionOption extends EditQuizViewEvent {
  const EditQuizAddQuestionOption(
      {required this.questionIndex, required this.option});

  final int questionIndex;
  final String option;

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex, option]; // coverage:ignore-line
}

class EditQuizChangeQuestionOption extends EditQuizViewEvent {
  const EditQuizChangeQuestionOption(
      {required this.questionIndex,
      required this.optionIndex,
      required this.option});

  final int questionIndex;
  final int optionIndex;
  final String option;

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex, optionIndex, option]; // coverage:ignore-line
}



class EditQuizDeleteQuestionOption extends EditQuizViewEvent {
  const EditQuizDeleteQuestionOption(
      {required this.questionIndex, required this.optionIndex});

  final int questionIndex;
  final int optionIndex;

  @override // coverage:ignore-line
  List<Object> get props => [questionIndex, optionIndex]; // coverage:ignore-line
}
