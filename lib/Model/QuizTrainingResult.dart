// // ignore_for_file: file_names
// import "package:json_annotation/json_annotation.dart";
// import 'package:flutter_food_app/Model/Quiz.dart';
// part "QuizTrainingResult.g.dart";

// // Classe qui doit manager le stockage local des résultats des quiz d'entrainements.
// // Pour générer le fichier complémentaire => flutter pub run build_runner build
// @JsonSerializable(explicitToJson: true)
// class QuizTrainingResult {
//   late final int id; // Identifiant unique
//   late final String quizName; // Nom du quiz
//   late final String quizNiveau; // Niveau scolaire du quiz
//   late final String quizMatiere; // Matiere du quiz
//   late final int quizCoefficient; // Coefficient du quiz
//   late final int timerQuiz; // temps en seconde pour une question du quiz
//   late final DateTime creationDate =
//       DateTime.now(); // Date de création du résultat

//   QuizTrainingResult(
//       {required this.id,
//       required this.quizName,
//       required this.quizNiveau,
//       required this.quizMatiere,
//       required this.quizCoefficient,
//       required this.timerQuiz});

//   // ignore: non_constant_identifier_names
//   QuizTrainingResult.FromQuiz({required Quiz quiz}) {
//     id = quiz.id;
//     quizName = quiz.name;
//     quizNiveau = quiz.niveau;
//     quizMatiere = quiz.matiere;
//     quizCoefficient = quiz.coefficient;
//     timerQuiz = quiz.timerQuiz;
//   }

//   @override
//   String toString() {
//     return "\n-------------------------------------------------"
//         "\nQuiz n°$id"
//         "\n  name: $quizName"
//         "\n  niveau: $quizNiveau"
//         "\n  matiere: $quizMatiere"
//         "\n  coefficient: $quizCoefficient"
//         "\n  timerQuiz: $timerQuiz"
//         "\n  isTraining: $creationDate";
//   }
// }
