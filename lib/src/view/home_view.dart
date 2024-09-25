import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/src/bloc/home_view/home_view_bloc.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';
import 'package:quiz_app/src/view/edit_quiz_view.dart';
import 'package:quiz_app/src/view/quiz_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeViewBloc(
        quizRepository: context.read<QuizRepository>(),
      )..add(const HomeViewSubscriptionRequested()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Quiz',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditQuizPage(
                quiz: Quiz.empty(),
                isNewQuiz: true,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        shape: CircleBorder(),
      ),
      body: BlocBuilder<HomeViewBloc, HomeViewState>(
        builder: (context, state) {
          if (state.quizzes.isEmpty) {
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
              child: state.status == HomeViewStatus.loading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                      radius: 16,
                      color: Colors.lime,
                    ))
                  : state.status != HomeViewStatus.success
                      ? const SizedBox()
                      : Center(
                          child: Text(
                            'No quizzes found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
            );
          }
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
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
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(state.quizzes[index].title),
                    subtitle: Text(state.quizzes[index].description),
                    trailing: Icon(Icons.arrow_forward_ios),
                    minTileHeight: 20,
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuizView(
                              quiz: state.quizzes[index],
                            ),
                          ),
                        );
                    },
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditQuizPage(
                            quiz: state.quizzes[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemCount: state.quizzes.length,
            ),
          );
        },
      ),
    );
  }
}
