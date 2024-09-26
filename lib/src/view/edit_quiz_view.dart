import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/src/bloc/edit_quiz_view/edit_quiz_view_bloc.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';

class EditQuizPage extends StatelessWidget {
  const EditQuizPage({
    Key? key,
    this.quiz,
    this.isNewQuiz = false,
  }) : super(key: key);

  final Quiz? quiz;
  final bool isNewQuiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditQuizViewBloc(
        quiz: quiz,
        isNewQuiz: isNewQuiz,
        quizRepository: context.read<QuizRepository>(),
      ),
      child: const EditQuizView(),
    );
  }
}

class EditQuizView extends StatelessWidget {
  const EditQuizView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<EditQuizViewBloc>().add(
                    EditQuizSubmitted(),
                  );
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.blue,
                Colors.purple,
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<EditQuizViewBloc, EditQuizViewState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.blue,
                Colors.purple,
              ],
            ),
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        state.title!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter quiz title',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (title) {
                          context.read<EditQuizViewBloc>().add(
                                EditQuizTitleChanged(title),
                              );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.description!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter quiz description',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (description) {
                          context.read<EditQuizViewBloc>().add(
                                EditQuizDescriptionChanged(description),
                              );
                        },
                      ),
                      const SizedBox(height: 16),
                      _ExisitingQuiz(
                        state: state,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<EditQuizViewBloc>().add(
                                EditQuizAddQuestion(),
                              );
                        },
                        child: const Text('Add Question'),
                      ),
                      const SizedBox(height: 16),

                    ],
                  ),
                ),

                    const SizedBox(height: 16),
                    if (!state.isNewQuiz)
                      ElevatedButton(
                        onPressed: () {
                          context.read<EditQuizViewBloc>().add(
                                EditQuizDelete(),
                              );
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Delete Quiz',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 134, 24, 16),
                        ),
                      ),
                    const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExisitingQuiz extends StatelessWidget {
  const _ExisitingQuiz({
    required this.state,
  });

  final EditQuizViewState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < state.questions!.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                state.questions![i].question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  labelText: 'Question ${i + 1}',
                  hintText: 'Enter question',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onChanged: (questionHeader) {
                  context.read<EditQuizViewBloc>().add(
                        EditQuizQuestionChanged(
                          questionIndex: i,
                          questionHeader: questionHeader,
                        ),
                      );
                },
              ),
              const SizedBox(height: 16),
              Text(
                state.questions![i].correctAnswer,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  labelText: 'What is the Correct Answer?',
                  hintText: 'Enter correct answer',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onChanged: (correctAnswer) {
                  context.read<EditQuizViewBloc>().add(
                        EdditQuizCorrectAnswerChanged(
                          questionIndex: i,
                          correctAnswer: correctAnswer,
                        ),
                      );
                },
              ),
              const SizedBox(height: 16),
              for (var j = 0; j < state.questions![i].options.length; j++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.questions![i].options[j],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () {
                            context.read<EditQuizViewBloc>().add(
                                  EditQuizDeleteQuestionOption(
                                    questionIndex: i,
                                    optionIndex: j,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Option ${j + 1}',
                        hintText: 'Enter option',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onChanged: (option) {
                        context.read<EditQuizViewBloc>().add(
                              EditQuizChangeQuestionOption(
                                questionIndex: i,
                                optionIndex: j,
                                option: option,
                              ),
                            );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<EditQuizViewBloc>().add(
                        EditQuizAddQuestionOption(questionIndex: i, option: ''),
                      );
                },
                child: const Text('Add Option'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<EditQuizViewBloc>().add(
                        EditQuizDeleteQuestion(questionIndex: i),
                      );
                },
                child: Text(
                  'Delete Question',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.red,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
      ],
    );
  }
}
