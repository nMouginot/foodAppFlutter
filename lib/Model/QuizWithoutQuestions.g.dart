// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'QuizWithoutQuestions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizWithoutQuestions _$QuizWithoutQuestionsFromJson(
        Map<String, dynamic> json) =>
    QuizWithoutQuestions(
      id: json['id'] as int,
      name: json['name'] as String,
      niveau: json['niveau'] as String,
      matiere: json['matiere'] as String,
      coefficient: json['coefficient'] as int,
      isTraining: json['isTraining'] as bool,
      timerQuiz: json['timerQuiz'] as int,
      creationDate: DateTime.parse(json['creationDate'] as String),
    )..storageFileName = json['storageFileName'] as String;

Map<String, dynamic> _$QuizWithoutQuestionsToJson(
        QuizWithoutQuestions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'niveau': instance.niveau,
      'matiere': instance.matiere,
      'coefficient': instance.coefficient,
      'isTraining': instance.isTraining,
      'timerQuiz': instance.timerQuiz,
      'creationDate': instance.creationDate.toIso8601String(),
      'storageFileName': instance.storageFileName,
    };
