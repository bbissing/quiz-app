part of 'edit_quiz_view_bloc.dart';

enum EditQuizViewStatus { initial, loading, success, failure }

extension EditQuizViewStatusX on EditQuizViewStatus {
  bool get isLoadingOrSuccess => [
        EditQuizViewStatus.loading,
        EditQuizViewStatus.success,
      ].contains(this);
}

class EditQuizViewState extends Equatable {
  const EditQuizViewState({
    this.status,
    this.initialQuiz,
    this.title,
    this.description,
    this.questions,
    this.isNewQuiz = false,
  });

  final Quiz? initialQuiz;
  final String? title;
  final String? description;
  final List<Question>? questions;
  final EditQuizViewStatus? status;
  final bool isNewQuiz;

  EditQuizViewState copyWith({
    Quiz? initialQuiz,
    String? title,
    String? description,
    List<Question>? questions,
    EditQuizViewStatus? status,
    bool? isNewQuiz,
  }) {
    return EditQuizViewState(
      status: status ?? this.status,
      initialQuiz: initialQuiz ?? this.initialQuiz,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      isNewQuiz: isNewQuiz ?? this.isNewQuiz,
    );
  }

  @override
  List<Object?> get props => [
    initialQuiz,
    isNewQuiz,
    status,
    title,
    description,
    questions,
  ];
}

