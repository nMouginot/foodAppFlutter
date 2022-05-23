// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      id: json['id'] as int,
      name: json['name'] as String,
      niveau: json['niveau'] as String,
      matiere: json['matiere'] as String,
      coefficient: json['coefficient'] as int,
      isTraining: json['isTraining'] as bool,
      timerQuiz: json['timerQuiz'] as int,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..skipped = json['skipped'] as int
      ..timeout = json['timeout'] as int
      ..userId = json['userId'] as int
      ..creationDate = DateTime.parse(json['creationDate'] as String)
      ..answerDate = DateTime.parse(json['answerDate'] as String)
      ..storageFileName = json['storageFileName'] as String
      ..result = (json['result'] as num).toDouble()
      ..totalCorrectAnswers = json['totalCorrectAnswers'] as int
      ..totalWrongAnswers = json['totalWrongAnswers'] as int;

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'niveau': instance.niveau,
      'matiere': instance.matiere,
      'coefficient': instance.coefficient,
      'isTraining': instance.isTraining,
      'timerQuiz': instance.timerQuiz,
      'skipped': instance.skipped,
      'timeout': instance.timeout,
      'userId': instance.userId,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'creationDate': instance.creationDate.toIso8601String(),
      'answerDate': instance.answerDate.toIso8601String(),
      'storageFileName': instance.storageFileName,
      'result': instance.result,
      'totalCorrectAnswers': instance.totalCorrectAnswers,
      'totalWrongAnswers': instance.totalWrongAnswers,
    };
