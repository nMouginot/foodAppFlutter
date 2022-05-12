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
      ..creationDate = DateTime.parse(json['creationDate'] as String)
      ..storageFileName = json['storageFileName'] as String;

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'niveau': instance.niveau,
      'matiere': instance.matiere,
      'coefficient': instance.coefficient,
      'isTraining': instance.isTraining,
      'timerQuiz': instance.timerQuiz,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'creationDate': instance.creationDate.toIso8601String(),
      'storageFileName': instance.storageFileName,
    };
