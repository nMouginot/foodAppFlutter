// ignore_for_file: file_names
import "package:json_annotation/json_annotation.dart";
import 'package:flutter_food_app/Model/Quiz.dart';
part "QuizWithoutQuestions.g.dart";

// Version sans question pour créer la liste json de tout les quiz. Les quiz complet sont stockés dans des fichiers individuel json.

// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class QuizWithoutQuestions {
  late final int id; // Identifiant unique du quiz
  late final String name; // Nom du quiz
  late final String niveau; // Niveau scolaire du quiz
  late final String matiere; // Matiere du quiz
  late final int coefficient; // Coefficient du quiz
  late final bool isTraining; // Quiz d"entrainement ou noté
  late final int timerQuiz; // temps en seconde pour une question du quiz
  late final DateTime
      creationDate; // Date de création du quiz, utilisé pour le nom du fichier json qui le stock.
  late String
      storageFileName; // Nom du fichier json qui stock le quiz avec les questions.

  QuizWithoutQuestions(
      {required this.id,
      required this.name,
      required this.niveau,
      required this.matiere,
      required this.coefficient,
      required this.isTraining,
      required this.timerQuiz,
      required this.creationDate}) {
    if (isTraining) {
      storageFileName =
          "QuizTraining${id}_${creationDate.day}-${creationDate.month}-${creationDate.year}.json";
    } else {
      storageFileName =
          "QuizGraded${id}_${creationDate.day}-${creationDate.month}-${creationDate.year}.json";
    }
  }

  // ignore: non_constant_identifier_names
  QuizWithoutQuestions.FromQuiz({required Quiz quiz}) {
    id = quiz.id;
    name = quiz.name;
    niveau = quiz.niveau;
    matiere = quiz.matiere;
    coefficient = quiz.coefficient;
    isTraining = quiz.isTraining;
    timerQuiz = quiz.timerQuiz;
    creationDate = quiz.creationDate;
    storageFileName = quiz.storageFileName;
  }

  @override
  String toString() {
    return "\n-------------------------------------------------"
        "\nQuiz n°$id"
        "\n  name: $name"
        "\n  niveau: $niveau"
        "\n  matiere: $matiere"
        "\n  coefficient: $coefficient"
        "\n  isTraining: $isTraining"
        "\n  timerQuiz: $timerQuiz"
        "\n  isTraining: $creationDate"
        "\n  isTraining: $storageFileName";
  }

  /// Connect the generated [_$QuizFromJson] function to the `fromJson` factory.
  factory QuizWithoutQuestions.fromJson(Map<String, dynamic> json) =>
      _$QuizWithoutQuestionsFromJson(json);

  /// Connect the generated [_$QuizToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuizWithoutQuestionsToJson(this);
}
