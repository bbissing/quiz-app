import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';

part 'home_view_event.dart';
part 'home_view_state.dart';

// Create Bloc
class HomeViewBloc extends Bloc<HomeViewEvent, HomeViewState> {
  HomeViewBloc({
    required QuizRepository quizRepository,
  }) : _quizRepository = quizRepository,
    super(const HomeViewState()) {
    on<HomeViewSubscriptionRequested>(_onSubscriptionRequested);
    on<HomeViewQuizDeleted>(_onQuizDeleted);
  }

  final QuizRepository _quizRepository;

  Future<void> _onSubscriptionRequested(
    HomeViewSubscriptionRequested event,
    Emitter<HomeViewState> emit,
  ) async {
    emit(state.copyWith(status: HomeViewStatus.loading));
    await emit.forEach<List<Quiz>>(
      await _quizRepository.getQuizzes(),
      onData: (quizzes) => state.copyWith(
        status: HomeViewStatus.success,
        quizzes: quizzes,
      ),
      onError: (error, stacktrace) => state.copyWith(
        status: HomeViewStatus.failure,
      ),
    );
  }

  Future<void> _onQuizDeleted(
    HomeViewQuizDeleted event,
    Emitter<HomeViewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedQuiz: event.quiz));
    await _quizRepository.deleteQuiz(event.quiz.id);
  }
}

