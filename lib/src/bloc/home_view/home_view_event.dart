part of 'home_view_bloc.dart';

// Define Events
sealed class HomeViewEvent extends Equatable {
  const HomeViewEvent();

  @override
  List<Object> get props => [];
}

final class HomeViewSubscriptionRequested extends HomeViewEvent {
  const HomeViewSubscriptionRequested();
}

final class HomeViewQuizDeleted extends HomeViewEvent {
  const HomeViewQuizDeleted(this.quiz);

  final Quiz quiz;

  @override
  List<Object> get props => [quiz];
}