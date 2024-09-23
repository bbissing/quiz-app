class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  final int id;
  final String title;
  final String description;
  final List<Map<String, dynamic>> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: List<Map<String, dynamic>>.from(json['questions'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions,
    };
  }
}