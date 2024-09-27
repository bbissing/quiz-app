import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/src/bloc/quiz_view/quiz_view_bloc.dart';
import 'package:quiz_app/src/model/quiz_model.dart';

class QuizView extends StatelessWidget {
  const QuizView({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizViewBloc(
        quiz: quiz,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            quiz.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
        body: BlocBuilder<QuizViewBloc, QuizViewState>(
          builder: (context, state) {
            return Container(
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
              child:
              !state.testSubmitted
              ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.quiz.questions.length,
                        itemBuilder: (context, index) {
                          final question = state.quiz.questions[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                if (index == 0) ...[
                                  Text(
                                    quiz.description,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          question.question,
                                          style: TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        ...question.options.map((option) {
                                          return ListTile(
                                            title: Text(option),
                                            leading: Radio(
                                              value: option,
                                              groupValue: state.selectedOptions[index],
                                              onChanged: (value) {
                                                context.read<QuizViewBloc>().add(
                                                  QuizViewSelectOption(
                                                    selectedOption: value as String,
                                                    questionIndex: index
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QuizViewBloc>().add(QuizViewSubmit());
                    },
                    child: Text('Submit Answers'),
                  ),
                  SizedBox(height: 16),
                ],
              )
              : Column(
                children: [
                  Text(
                    'Your Score: ${state.score/state.quiz.questions.length * 100}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: state.score / state.quiz.questions.length * 100 >= 50 ? const Color.fromARGB(255, 16, 109, 19) : Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You got ${state.score} out of ${state.quiz.questions.length} questions right',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.incorrectAnswers.length,
                      itemBuilder: (context, index) {
                        final questionIndex = state.incorrectAnswers[index];
                        final question = context.read<QuizViewBloc>().state.quiz.questions[questionIndex];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.question,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Correct Answer: ${question.correctAnswer}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    'Your Answer: ${state.selectedOptions[questionIndex] ?? 'Unanswered'}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            );
          }
        ),
      ),
    );
  }
}
