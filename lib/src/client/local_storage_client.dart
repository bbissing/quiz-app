import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:quiz_app/src/client/quiz_client_interface.dart';
import 'package:quiz_app/src/model/quiz_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageClient extends QuizClientInterface {
  LocalStorageClient({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  late final _quizStreamController = BehaviorSubject<List<Quiz>>.seeded([]);

  Stream<List<Quiz>> get quizStream => _quizStreamController.stream;

  @visibleForTesting
  static const kTodosCollectionKey = 'test_key';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) {
    var result = _plugin.setString(key, value);
    return result;
  }

  void _init() {
    final quizJson = _getValue(kTodosCollectionKey);
    if (quizJson != null) {
      final quizzes = List<Map<dynamic, dynamic>>.from(
              jsonDecode(quizJson) as List<dynamic>)
          .map((jsonMap) => Quiz.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _quizStreamController.add(quizzes);
    } else {
      _quizStreamController.add(const []);
    }
  }

  @override
  Future<Stream<List<Quiz>>> getQuizzes() async {
    await Future.delayed(const Duration(seconds: 1));
    return _quizStreamController.stream;
  }

  @override
  Future<void> createQuiz(Quiz quiz) async {
    if (_quizStreamController.value.length != 0) {
      quiz = quiz.copyWith(id: _quizStreamController.value.last.id + 1);
    }

    final quizzes = [..._quizStreamController.value];
    quizzes.add(quiz);

    String json = jsonEncode(quizzes.map((quiz) => quiz.toJson()).toList());
    _quizStreamController.add(quizzes);
    return _setValue(kTodosCollectionKey, json);
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    final quizzes = _quizStreamController.value;
    final index = quizzes.indexWhere((element) => element.id == quiz.id);
    quizzes[index] = quiz;
    _quizStreamController.add(quizzes);
  }

  @override
  Future<void> deleteQuiz(int id) async {
    final quizzes = [..._quizStreamController.value];
    final quizIndex = quizzes.indexWhere((element) => element.id == id);
    if (quizIndex == -1) {
      throw QuizNotFoundException();
    } else {
      quizzes.removeAt(quizIndex);
      _quizStreamController.add(quizzes);
      return _setValue(kTodosCollectionKey, json.encode(quizzes));
    }
  }

  @override
  Future<void> close() async {
    await _quizStreamController.close();
  }
}
