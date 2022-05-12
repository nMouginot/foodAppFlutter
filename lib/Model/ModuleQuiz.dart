// ignore_for_file: file_names
import "package:json_annotation/json_annotation.dart";
import 'package:flutter_food_app/Model/Quiz.dart';
part "ModuleQuiz.g.dart";

// Classe qui doit manager le stockage local des résultats des quiz d'entrainements.
// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class ModuleQuiz {
  late final int id; // Identifiant unique de ce module
  late int
      idSorting; // Id utiliser pour définir l'ordre des modules dans le mainModule
  late String moduleName; // Name of the module
  late String description; // Description of the module
  late int completionOfTheModule =
      0; // Valeur entre 0 et 100 qui indique le taux de completion du module

  set name(String value) => moduleName = value;
  String get name => "Quiz:$moduleName";

  late Quiz quiz; // quiz attaché à ce module
  int get numberOfQuestions =>
      quiz.questions.length; // Nombre de question dans le quiz de ce module.
  int get timer =>
      _computeTimer(); // Temps requis en minute pour completer ce module.
  int _computeTimer() {
    int result = 0;
    if (quiz.questions.isNotEmpty) {
      result = ((quiz.timerQuiz * quiz.questions.length) / 60).truncate();
    }
    return result;
  }

  ModuleQuiz({
    required int id,
    required this.moduleName,
    required this.description,
  }) {
    completionOfTheModule = 0;
  }

  @override
  String toString() {
    return "\n-------------------------------------------------"
        "\nQuiz n°$id"
        "\n  name: $name"
        "\n  description: $description"
        "\n  completionOfTheModule: $completionOfTheModule"
        "\n  numberOfQuestions: $numberOfQuestions"
        "\n  timer: $timer";
  }

  /// Connect the generated [_$ModuleQuizFromJson] function to the `fromJson` factory.
  factory ModuleQuiz.fromJson(Map<String, dynamic> json) =>
      _$ModuleQuizFromJson(json);

  /// Connect the generated [_$ModuleQuizToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ModuleQuizToJson(this);
}
