part of 'quiz_view_bloc.dart';

enum QuizViewStatus { initial, loading, success, failure }

class QuizViewState extends Equatable {
  const QuizViewState({
    required this.quiz,
    this.selectedOptions = const {},
    this.score = 0,
    this.incorrectAnswers = const [],
    this.testSubmitted = false,
  });

  final Quiz quiz;
  final Map<int, String> selectedOptions;
  final int score;
  final List<int> incorrectAnswers;
  final bool testSubmitted;

  @override
  List<Object?> get props => [
    quiz,
    selectedOptions,
    score,
    incorrectAnswers,
    testSubmitted,
  ];

  QuizViewState copyWith({
    Quiz? quiz,
    Map<int, String>? selectedOptions,
    int? score,
    List<int>? incorrectAnswers,
    bool? testSubmitted,
  }) {
    return QuizViewState(
      quiz: quiz ?? this.quiz,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      score: score ?? this.score,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      testSubmitted: testSubmitted ?? this.testSubmitted,
    );
  }
}

