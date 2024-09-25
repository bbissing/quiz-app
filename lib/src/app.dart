import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';
import 'package:quiz_app/src/view/home_view.dart';

class App extends StatelessWidget {
  const App({required this.quizRepository, super.key});

  final QuizRepository quizRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: quizRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Quiz App',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}