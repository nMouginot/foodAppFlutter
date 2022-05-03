// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'QuizQuestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as int,
      idSorting: json['idSorting'] as int,
      question: json['question'] as String,
      answer1: json['answer1'] as String,
      answer2: json['answer2'] as String,
      answer3: json['answer3'] as String,
      answer4: json['answer4'] as String,
      answerTextFromUser: json['answerTextFromUser'] as String,
      answersDisplay: json['answersDisplay'] as String,
      correctAnswers: (json['correctAnswers'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'idSorting': instance.idSorting,
      'question': instance.question,
      'answer1': instance.answer1,
      'answer2': instance.answer2,
      'answer3': instance.answer3,
      'answer4': instance.answer4,
      'answerTextFromUser': instance.answerTextFromUser,
      'answersDisplay': instance.answersDisplay,
      'correctAnswers': instance.correctAnswers,
    };
