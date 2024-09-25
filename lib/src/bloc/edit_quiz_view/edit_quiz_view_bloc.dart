import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/src/model/question_model.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';

part 'edit_quiz_view_event.dart';
part 'edit_quiz_view_state.dart';

class EditQuizViewBloc extends Bloc<EditQuizViewEvent, EditQuizViewState> {
  EditQuizViewBloc({
    required QuizRepository quizRepository,
    required Quiz? quiz,
    bool? isNewQuiz,
  })  : _quizRepository = quizRepository,
        super(EditQuizViewState(
          status: EditQuizViewStatus.initial,
          initialQuiz: quiz,
          title: quiz?.title ?? '',
          description: quiz?.description ?? '',
          questions: quiz?.questions,
          isNewQuiz: isNewQuiz ?? false,
        )) {
    on<EditQuizTitleChanged>(_onTitleChanged);
    on<EditQuizDescriptionChanged>(_onDescriptionChanged);
    on<EditQuizAddQuestion>(_onAddQuestion);
    on<EditQuizQuestionChanged>(_onChangeQuestion);
    on<EditQuizDeleteQuestion>(_onDeleteQuestion);
    on<EditQuizAddQuestionOption>(_onAddQuestionOption);
    on<EditQuizChangeQuestionOption>(_onChangeQuestionOption);
    on<EditQuizSubmitted>(_onQuizSubmitted);
    on<EditQuizDelete>(_onDeleteQuiz);
    on<EditQuizAnswerSubmitted>(_onAnswerSubmitted);
    on<EdditQuizCorrectAnswerChanged>(_onCorrectAnswerChanged);
  }

  final QuizRepository _quizRepository;

  void _onTitleChanged(
    EditQuizTitleChanged event,
    Emitter<EditQuizViewState> emit,
  ) {
    emit(state.copyWith(
      title: event.title,
    ));
  }

  void _onDescriptionChanged(
    EditQuizDescriptionChanged event,
    Emitter<EditQuizViewState> emit,
  ) {
    emit(state.copyWith(
      description: event.description,
    ));
  }

  void _onCorrectAnswerChanged(
    EdditQuizCorrectAnswerChanged event,
    Emitter<EditQuizViewState> emit,
  ) {
    final List<Question> questions = List<Question>.from(state.questions!);
    var newQuestion = questions[event.questionIndex]
        .copyWith(correctAnswer: event.correctAnswer);
    emit(state.copyWith(
        questions: List<Question>.from(state.questions!)
            .map((question) => question == questions[event.questionIndex]
                ? newQuestion
                : question)
            .toList()));
  }

  void _onAddQuestion(
    EditQuizAddQuestion event,
    Emitter<EditQuizViewState> emit,
  ) {
      final Question question = Question(
        question: 'Question ${state.questions!.length + 1}',
        options: [
          'Option 1',
          'Option 2',
        ],
        correctAnswer: '',
      );
    if (state.questions == null) {
      emit(state.copyWith(questions: [question]));
    } else {
      emit(state.copyWith(
        questions: List<Question>.from(state.questions!)..add(question),
      ));
    }
  }

  void _onChangeQuestion(
    EditQuizQuestionChanged event,
    Emitter<EditQuizViewState> emit,
  ) {
    if (state.questions == null) {
      emit(state.copyWith(questions: [
        Question(question: event.questionHeader, options: [], correctAnswer: '')
      ]));
    } else {
      final List<Question> questions = List<Question>.from(state.questions!);
      var newQuestion = questions[event.questionIndex]
          .copyWith(question: event.questionHeader);
      emit(state.copyWith(
          questions: List<Question>.from(state.questions!)
              .map((question) => question == questions[event.questionIndex]
                  ? newQuestion
                  : question)
              .toList()));
    }
  }

  void _onDeleteQuestion(
    EditQuizDeleteQuestion event,
    Emitter<EditQuizViewState> emit,
  ) {
    final List<Question> questions = List<Question>.from(state.questions!);
    questions.removeAt(event.index);
    emit(state.copyWith(questions: questions));
  }

  void _onAddQuestionOption(
    EditQuizAddQuestionOption event,
    Emitter<EditQuizViewState> emit,
  ) {
    if (state.questions == null) {
      emit(state.copyWith(questions: [
        Question(question: '', options: [event.option], correctAnswer: '')
      ]));
    } else {
    final List<Question> questions = List<Question>.from(state.questions!);
    final List<String> options =
        List<String>.from(questions[event.questionIndex].options);
    options.add(event.option);
    var newQuestion = questions[event.questionIndex].copyWith(options: options);
    emit(state.copyWith(
        questions: List<Question>.from(state.questions!)
            .map((question) => question == questions[event.questionIndex]
                ? newQuestion
                : question)
            .toList()));
    }

  }

  void _onChangeQuestionOption(
    EditQuizChangeQuestionOption event,
    Emitter<EditQuizViewState> emit,
  ) {
    if (state.questions == null) {
      emit(state.copyWith(questions: [
        Question(question: '', options: [event.option], correctAnswer: '')
      ]));
    } else {
      final List<Question> questions = List<Question>.from(state.questions!);
      final List<String> options =
          List<String>.from(questions[event.questionIndex].options);
      if (options.length <= event.optionIndex) {
        options.add(event.option);
      } else {
        options[event.optionIndex] = event.option;
      }
      var newQuestion =
          questions[event.questionIndex].copyWith(options: options);
      emit(state.copyWith(
          questions: List<Question>.from(state.questions!)
              .map((question) => question == questions[event.questionIndex]
                  ? newQuestion
                  : question)
              .toList()));
    }
  }

  Future<void> _onQuizSubmitted(
    EditQuizSubmitted event,
    Emitter<EditQuizViewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditQuizViewStatus.loading));
      if (state.isNewQuiz) {
        await _quizRepository.createQuiz(
          Quiz(
            id: 0,
            title: state.title!,
            description: state.description!,
            questions: state.questions!,
          ),
        );
      } else {
        await _quizRepository.updateQuiz(
          state.initialQuiz!.copyWith(
            title: state.title!,
            description: state.description!,
            questions: state.questions!,
          ),
        );
      }
      emit(state.copyWith(status: EditQuizViewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditQuizViewStatus.failure));
    }
  }

  Future<void> _onDeleteQuiz(
    EditQuizDelete event,
    Emitter<EditQuizViewState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditQuizViewStatus.loading));
      await _quizRepository.deleteQuiz(state.initialQuiz!.id);
      emit(state.copyWith(status: EditQuizViewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditQuizViewStatus.failure));
    }
  }

  Future<void> _onAnswerSubmitted(
    EditQuizAnswerSubmitted event,
    Emitter<EditQuizViewState> emit,
  ) async {
    Question question = state.questions![event.index];
    final String selectedAnswer = question.options[event.optionIndex];
    question = question.copyWith(selectedAnswer: selectedAnswer);
  }
}
