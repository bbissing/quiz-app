import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app/src/bloc/edit_quiz_view/edit_quiz_view_bloc.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';

class MockQuizRepository extends Mock implements QuizRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Quiz(
      id: 1,
      title: '',
      description: '',
      questions: [
        Question(
          question: '',
          options: [''],
          correctAnswer: '',
        ),
      ],
    ));
  });

  group('EditQuizViewBloc', () {
    late QuizRepository quizRepository;
    late Quiz mockQuiz;

    setUp(() {
      quizRepository = MockQuizRepository();
      mockQuiz = Quiz(
        id: 1,
        title: 'Mock Quiz',
        description: 'A mock quiz for testing',
        questions: [
          Question(
            question: 'Mock Question',
            options: ['Option 1', 'Option 2'],
            correctAnswer: 'Option 1',
          ),
        ],
      );
    });

    EditQuizViewBloc buildBloc() {
      return EditQuizViewBloc(
        quizRepository: quizRepository,
        quiz: mockQuiz,
        isNewQuiz: false,
      );
    }

    test('initial state is correct', () {
      final bloc = buildBloc();
      expect(bloc.state.status, equals(EditQuizViewStatus.initial));
      expect(bloc.state.title, equals(mockQuiz.title));
      expect(bloc.state.description, equals(mockQuiz.description));
      expect(bloc.state.questions, equals(mockQuiz.questions));
      expect(bloc.state.isNewQuiz, isFalse);
      expect(bloc.state.initialQuiz, equals(mockQuiz));
    });

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated title when EditQuizTitleChanged is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizTitleChanged('New Title')),
      expect: () => [
        isA<EditQuizViewState>()
            .having((state) => state.title, 'title', 'New Title'),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated description when EditQuizDescriptionChanged is added',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const EditQuizDescriptionChanged('New Description')),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.description, 'description', 'New Description'),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with added question when EditQuizAddQuestion is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizAddQuestion()),
      expect: () => [
        isA<EditQuizViewState>().having(
          (state) => state.questions!.length,
          'questions length',
          mockQuiz.questions.length + 1,
        ),
      ],
    );

  blocTest<EditQuizViewBloc, EditQuizViewState>(
        'emits success state when EditQuizSubmitted is added for existing quiz',
        build: buildBloc,
        act: (bloc) {
          bloc.add(const EditQuizTitleChanged('New Title'));
          bloc.add(const EditQuizDescriptionChanged('New Description'));
          bloc.add(const EditQuizChangeQuestionOption(
              questionIndex: 0, optionIndex: 0, option: 'New Option'));
          bloc.add(const EditQuizSubmitted());
        },
        setUp: () {
          // when(() => quizRepository.updateQuiz(any())).thenAnswer((_) async => mockQuiz);
          when(() => quizRepository.updateQuiz(any())).thenAnswer((_) async => null);
        },
        expect: () => [
          isA<EditQuizViewState>()
            .having((state) => state.status, 'status', EditQuizViewStatus.initial)
            .having((state) => state.title, 'title', 'New Title')
            .having((state) => state.description, 'description', 'A mock quiz for testing')
            .having((state) => state.questions, 'questions', mockQuiz.questions)
            .having((state) => state.isNewQuiz, 'isNewQuiz', false),
          isA<EditQuizViewState>()
            .having((state) => state.status, 'status', EditQuizViewStatus.initial)
            .having((state) => state.title, 'title', 'New Title')
            .having((state) => state.description, 'description', 'New Description')
            .having((state) => state.questions, 'questions', mockQuiz.questions)
            .having((state) => state.isNewQuiz, 'isNewQuiz', false),
          isA<EditQuizViewState>()
            .having((state) => state.status, 'status', EditQuizViewStatus.initial)
            .having((state) => state.title, 'title', 'New Title')
            .having((state) => state.description, 'description', 'New Description')
            .having((state) => state.questions![0].options[0], 'option', 'New Option')
            .having((state) => state.isNewQuiz, 'isNewQuiz', false),
          isA<EditQuizViewState>()
            .having((state) => state.status, 'status', EditQuizViewStatus.loading)
            .having((state) => state.title, 'title', 'New Title')
            .having((state) => state.description, 'description', 'New Description')
            .having((state) => state.questions![0].options[0], 'option', 'New Option')
            .having((state) => state.isNewQuiz, 'isNewQuiz', false),
          isA<EditQuizViewState>()
            .having((state) => state.description, 'description', 'New Description')
            .having((state) => state.title, 'title', 'New Title')
            .having((state) => state.questions![0].options[0], 'option', 'New Option')
            .having((state) => state.status, 'status', EditQuizViewStatus.success)
            .having((state) => state.isNewQuiz, 'isNewQuiz', false),
        ],
        verify: (_) {
          verify(() => quizRepository.updateQuiz(any())).called(1);
        },
      );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits failure state when EditQuizSubmitted fails',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizSubmitted()),
      setUp: () {
        when(() => quizRepository.updateQuiz(mockQuiz))
            .thenThrow(Exception('Failed to update quiz'));
      },
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.loading),
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.failure),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits success state when EditQuizSubmitted is added for new quiz',
      build: () {
        when(() => quizRepository.createQuiz(any()))
            .thenAnswer((_) async => mockQuiz);
        return EditQuizViewBloc(
          quizRepository: quizRepository,
          quiz: mockQuiz,
          isNewQuiz: true,
        );
      },
      act: (bloc) => bloc.add(const EditQuizSubmitted()),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.loading),
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.success),
      ],
      verify: (_) {
        verify(() => quizRepository.createQuiz(any())).called(1);
      },
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits failure state when EditQuizSubmitted fails for new quiz',
      build: () {
        when(() => quizRepository.createQuiz(mockQuiz))
            .thenThrow(Exception('Failed to create quiz'));
        return EditQuizViewBloc(
          quizRepository: quizRepository,
          quiz: mockQuiz,
          isNewQuiz: true,
        );
      },
      act: (bloc) => bloc.add(const EditQuizSubmitted()),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.loading),
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.failure),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits success state when EditQuizDeleted is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizDelete()),
      setUp: () {
        when(() => quizRepository.deleteQuiz(any())).thenAnswer((_) async {});
      },
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.loading),
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.success),
      ],
      verify: (_) {
        verify(() => quizRepository.deleteQuiz(any())).called(1);
      },
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits failure state when EditQuizDeleted fails',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizDelete()),
      setUp: () {
        when(() => quizRepository.deleteQuiz(any()))
            .thenThrow(Exception('Failed to delete quiz'));
      },
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.loading),
        isA<EditQuizViewState>().having(
            (state) => state.status, 'status', EditQuizViewStatus.failure),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated question when EditQuizQuestionChanged is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizQuestionChanged(
          questionIndex: 0, questionHeader: 'New Question')),
      expect: () => [
        isA<EditQuizViewState>().having((state) => state.questions![0].question,
            'question', 'New Question'),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated option when EditQuizOptionChanged is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizChangeQuestionOption(
          questionIndex: 0, optionIndex: 0, option: 'New Option')),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.questions![0].options[0], 'option', 'New Option'),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated option when EditQuizOptionChanged is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizChangeQuestionOption(
          questionIndex: 0, optionIndex: 0, option: 'New Option')),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.questions![0].options[0], 'option', 'New Option'),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated question when EditQuizDeleteQuestion is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizDeleteQuestion(questionIndex: 0)),
      expect: () => [
        isA<EditQuizViewState>().having((state) => state.questions!.length,
            'questions length', mockQuiz.questions.length - 1),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated option when EditQuizDeleteQuestionOption is added',
      build: buildBloc,
      act: (bloc) => bloc.add(
          const EditQuizDeleteQuestionOption(questionIndex: 0, optionIndex: 0)),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.questions![0].options.length,
            'options length',
            mockQuiz.questions[0].options.length - 1),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated correct answer when EdditQuizCorrectAnswerChanged is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EdditQuizCorrectAnswerChanged(
          questionIndex: 0, correctAnswer: 'New Correct Answer')),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.questions![0].correctAnswer,
            'correct answer',
            'New Correct Answer'),
      ],
    );

    blocTest<EditQuizViewBloc, EditQuizViewState>(
      'emits new state with updated option when EditQuizAddQuestionOption is added',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditQuizAddQuestionOption(
          questionIndex: 0, option: 'New Option')),
      expect: () => [
        isA<EditQuizViewState>().having(
            (state) => state.questions![0].options.length,
            'options length',
            mockQuiz.questions[0].options.length + 1),
      ],
    );
  });
}
