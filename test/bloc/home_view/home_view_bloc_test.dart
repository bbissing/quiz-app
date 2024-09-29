import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app/src/bloc/home_view/home_view_bloc.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';

class MockQuizRepository extends Mock implements QuizRepository {}

void main() {
  late HomeViewBloc homeViewBloc;
  late QuizRepository quizRepository;

  setUpAll(() {
    quizRepository = MockQuizRepository();
  });

  group('HomeViewBloc initalized', () {
    setUp(() {
      homeViewBloc = HomeViewBloc(
        quizRepository: quizRepository,
      );
    });
    test('- initial state is HomeViewState', () {
      expect(homeViewBloc.state, const HomeViewState());
      expect(homeViewBloc.state.status, HomeViewStatus.initial);
      expect(homeViewBloc.state.quizzes, []);
      expect(homeViewBloc.state.lastDeletedQuiz, null);
    });

    blocTest<HomeViewBloc, HomeViewState>(
      '- emits [] when nothing is added',
      build: () => homeViewBloc,
      expect: () => const <HomeViewState>[],
    );
  });

  group('HomeViewSubscriptionRequested event added to HomeViewBloc - emits HomeViewStatus.success, zero quizzes', () {
    blocTest<HomeViewBloc, HomeViewState>(
      'emits [HomeViewState(status: HomeViewStatus.loading), HomeViewState(status: HomeViewStatus.success, quizzes: [])] when HomeViewSubscriptionRequested is added',
      build: () => HomeViewBloc(quizRepository: quizRepository),
      setUp: () {
        when(() => quizRepository.getQuizzes())
            .thenAnswer((_) async => Stream.fromIterable([[]]));
      },
      act: (bloc) => bloc.add(HomeViewSubscriptionRequested()),
      expect: () => const <HomeViewState>[
        HomeViewState(status: HomeViewStatus.loading),
        HomeViewState(status: HomeViewStatus.success, quizzes: []),
      ],
      verify: (_) {
        verify(() => quizRepository.getQuizzes()).called(1);
      },
    );
  });

  group('HomeViewSubscriptionRequested event added to HomeViewBloc - emits HomeViewStatus.failure', () {
    blocTest<HomeViewBloc, HomeViewState>(
      'emits [HomeViewState(status: HomeViewStatus.loading), HomeViewState(status: HomeViewStatus.failure)] when HomeViewSubscriptionRequested is added',
      build: () => HomeViewBloc(quizRepository: quizRepository),
      setUp: () {
        when(() => quizRepository.getQuizzes())
            .thenAnswer((_) async => Stream.error(Exception('error')));
      },
      act: (bloc) => bloc.add(HomeViewSubscriptionRequested()),
      expect: () => const <HomeViewState>[
        HomeViewState(status: HomeViewStatus.loading),
        HomeViewState(status: HomeViewStatus.failure),
      ],
      verify: (_) {
        verify(() => quizRepository.getQuizzes()).called(1);
      },
    );
  });
}
