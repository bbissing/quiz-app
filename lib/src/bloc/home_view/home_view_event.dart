part of 'home_view_bloc.dart';

// Define Events
sealed class HomeViewEvent extends Equatable {
  const HomeViewEvent();

  @override // coverage:ignore-line
  List<Object> get props => []; // coverage:ignore-line
}

final class HomeViewSubscriptionRequested extends HomeViewEvent {
  const HomeViewSubscriptionRequested();
}