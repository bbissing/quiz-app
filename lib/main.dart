import 'package:flutter/widgets.dart';
import 'package:quiz_app/src/app.dart';
import 'package:quiz_app/src/client/local_storage_client.dart';
import 'package:quiz_app/src/repository/quiz_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final quizApi = LocalStorageClient(
    plugin: await SharedPreferences.getInstance(),
  );

  final quizRepository = QuizRepository(quizApi: quizApi);

  runApp(App(quizRepository: quizRepository,));
}