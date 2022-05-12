// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModuleQuiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleQuiz _$ModuleQuizFromJson(Map<String, dynamic> json) => ModuleQuiz(
      id: json['id'] as int,
      moduleName: json['moduleName'] as String,
      description: json['description'] as String,
    )
      ..idSorting = json['idSorting'] as int
      ..completionOfTheModule = json['completionOfTheModule'] as int
      ..name = json['name'] as String
      ..quiz = Quiz.fromJson(json['quiz'] as Map<String, dynamic>);

Map<String, dynamic> _$ModuleQuizToJson(ModuleQuiz instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idSorting': instance.idSorting,
      'moduleName': instance.moduleName,
      'description': instance.description,
      'completionOfTheModule': instance.completionOfTheModule,
      'name': instance.name,
      'quiz': instance.quiz.toJson(),
    };
