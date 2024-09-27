import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app/src/bloc/home_view/home_view_bloc.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';

class MockQuizRepository extends Mock implements QuizRepository {}

void main() {
  group('HomeViewBloc initalized', () {
    late HomeViewBloc homeViewBloc;
    late QuizRepository quizRepository;

    setUp(() {
      print('inside setUp');
      quizRepository = MockQuizRepository();
      homeViewBloc = HomeViewBloc(
        quizRepository: quizRepository,
      );
    });

    print('after setUp');

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

    tearDown(() {
      homeViewBloc.close();
    });
  });

  group('HomeViewSubscriptionRequested event added to HomeViewBloc', () {
    // late MockQuizRepository quizRepository;
    // late HomeViewBloc homeViewBloc;

    // setUp(() {
    //   quizRepository = MockQuizRepository();
    //   homeViewBloc = HomeViewBloc(
    //     quizRepository: quizRepository,
    //   );
    // });
    final quizRepository = MockQuizRepository();
    final homeViewBloc = HomeViewBloc(
      quizRepository: quizRepository,
    );

    when(() => quizRepository.getQuizzes())
        .thenAnswer((_) async => Stream.fromIterable([[]]));

    blocTest<HomeViewBloc, HomeViewState>(
      'emits [HomeViewState(status: HomeViewStatus.loading), HomeViewState(status: HomeViewStatus.success, quizzes: [])] when HomeViewSubscriptionRequested is added',
      build: () => homeViewBloc,
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

  group('HomeViewBloc with quizRepository', () {
    final quizRepository = MockQuizRepository();
    final homeViewBloc = HomeViewBloc(
      quizRepository: quizRepository,
    );

    when(() => quizRepository.getQuizzes()).thenAnswer((_) async => Stream.error(Exception('error')));

    blocTest<HomeViewBloc, HomeViewState>(
      'emits [HomeViewState(status: HomeViewStatus.loading), HomeViewState(status: HomeViewStatus.failure)] when HomeViewSubscriptionRequested is added',
      build: () => homeViewBloc,
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
