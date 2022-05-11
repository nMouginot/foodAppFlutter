// ignore_for_file: file_names
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';

import "QuizQuestion.dart";
import "package:json_annotation/json_annotation.dart";
part "Quiz.g.dart";

// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class Quiz {
  late final int id; // Identifiant unique du quiz
  late final String name; // Nom du quiz
  late final String niveau; // Niveau scolaire du quiz
  late final String matiere; // Matiere du quiz
  late final int coefficient; // Coefficient du quiz
  late final bool isTraining; // Quiz d"entrainement ou noté
  late final int timerQuiz; // temps en seconde pour une question du quiz
  late final List<Question> questions; // Liste des questions du quiz
  late DateTime creationDate = DateTime
      .now(); // Date de création du quiz, utilisé pour le nom du fichier json qui le stock.
  late String
      storageFileName; // Nom du fichier json qui stock le quiz avec les questions. Stucture = (QuizTraining||QuizGraded)+$id_$creationDateDay-$creationDateMonth-$creationDateYear.json

  Quiz(
      {required this.id,
      required this.name,
      required this.niveau,
      required this.matiere,
      required this.coefficient,
      required this.isTraining,
      required this.timerQuiz,
      required this.questions}) {
    if (isTraining) {
      storageFileName =
          "QuizTraining${id}_${creationDate.day}-${creationDate.month}-${creationDate.year}.json";
    } else {
      storageFileName =
          "QuizGraded${id}_${creationDate.day}-${creationDate.month}-${creationDate.year}.json";
    }
  }

  Quiz.fromQuizWithoutQuestions(
      {required QuizWithoutQuestions quiz, required this.questions}) {
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
    return "Quiz n°$id"
        "\n  name: $name"
        "\n  niveau: $niveau"
        "\n  matiere: $matiere"
        "\n  coefficient: $coefficient"
        "\n  isTraining: $isTraining"
        "\n  timerQuiz: $timerQuiz"
        "\n  numberOfQuestions: ${questions.length}";
  }

  /// Connect the generated [_$QuizFromJson] function to the `fromJson` factory.
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  /// Connect the generated [_$QuizToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuizToJson(this);

  // Désérialisation
  // Map<String, dynamic> userMap = jsonDecode(jsonString);
  // var user = User.fromJson(userMap);

  // Sérialisation
  // String json = jsonEncode(user);
}
