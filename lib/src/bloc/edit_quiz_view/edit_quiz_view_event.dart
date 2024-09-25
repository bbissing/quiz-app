part of 'edit_quiz_view_bloc.dart';

sealed class EditQuizViewEvent extends Equatable {
  const EditQuizViewEvent();

  @override
  List<Object> get props => [];
}

class EditQuizSubmitted extends EditQuizViewEvent {
  const EditQuizSubmitted();

  @override
  List<Object> get props => [];
}

class EditQuizDelete extends EditQuizViewEvent {
  // const EditQuizDelete(this.id);
  const EditQuizDelete();

  // final int id;

  // @override
  // List<Object> get props => [id];
}

class EditQuizTitleChanged extends EditQuizViewEvent {
  const EditQuizTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditQuizDescriptionChanged extends EditQuizViewEvent {
  const EditQuizDescriptionChanged(this.description);
  final String description;

  @override
  List<Object> get props => [description];
}

class EditQuizAddQuestion extends EditQuizViewEvent {
  const EditQuizAddQuestion();

  @override
  List<Object> get props => [];
}

class EdditQuizCorrectAnswerChanged extends EditQuizViewEvent {
  const EdditQuizCorrectAnswerChanged(
      {required this.questionIndex, required this.correctAnswer});

  final int questionIndex;
  final String correctAnswer;

  @override
  List<Object> get props => [questionIndex, correctAnswer];
}

class EditQuizQuestionChanged extends EditQuizViewEvent {
  const EditQuizQuestionChanged(
      {required this.questionIndex, required this.questionHeader});

  final int questionIndex;
  final String questionHeader;

  @override
  List<Object> get props => [questionIndex, questionHeader];
}

class EditQuizDeleteQuestion extends EditQuizViewEvent {
  const EditQuizDeleteQuestion(this.quiz, this.index);

  final Quiz quiz;
  final int index;

  @override
  List<Object> get props => [quiz, index];
}

class EditQuizAddQuestionOption extends EditQuizViewEvent {
  const EditQuizAddQuestionOption(
      {required this.questionIndex, required this.option});

  final int questionIndex;
  final String option;

  @override
  List<Object> get props => [questionIndex, option];
}

class EditQuizChangeQuestionOption extends EditQuizViewEvent {
  const EditQuizChangeQuestionOption(
      {required this.questionIndex,
      required this.optionIndex,
      required this.option});

  final int questionIndex;
  final int optionIndex;
  final String option;

  @override
  List<Object> get props => [questionIndex, optionIndex, option];
}

class EditQuizAnswerSubmitted extends EditQuizViewEvent {
  const EditQuizAnswerSubmitted(
      this.quiz, this.index, this.optionIndex, this.option);

  final Quiz quiz;
  final int index;
  final int optionIndex;
  final String option;

  @override
  List<Object> get props => [quiz, index, optionIndex, option];
}
