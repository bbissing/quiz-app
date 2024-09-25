part of 'home_view_bloc.dart';

enum HomeViewStatus { initial, loading, success, failure }

final class HomeViewState extends Equatable {
  const HomeViewState({
    this.status = HomeViewStatus.initial,
    this.quizzes = const [],
    this.lastDeletedQuiz,
  });

  final HomeViewStatus status;
  final List<Quiz> quizzes;
  final Quiz? lastDeletedQuiz;

  HomeViewState copyWith({
    HomeViewStatus? status,
    List<Quiz>? quizzes,
    Quiz? lastDeletedQuiz,
  }) {
    return HomeViewState(
      status: status != null ? status : this.status,
      quizzes: quizzes != null ? quizzes : this.quizzes,
      lastDeletedQuiz: lastDeletedQuiz,
    );
  }

  @override
  List<Object?> get props => [
    status,
    quizzes,
  ];
}