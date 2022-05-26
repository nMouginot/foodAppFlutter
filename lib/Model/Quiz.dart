// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MainModule.dart';
import 'package:flutter_food_app/Model/ModuleId.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/play_quiz.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';
import "QuizQuestion.dart";
import "package:json_annotation/json_annotation.dart";
part "Quiz.g.dart";

// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class Quiz {
  /// Identifiant unique du quiz
  late final int id;

  /// Identifiant unique de la version "vide" du quiz. (Peut exister en plusieurs valeurs indentique dans les userResults)
  late final int quizId;

  /// Nom du quiz
  late final String name;

  /// Niveau scolaire du quiz
  late final String niveau;

  /// Matiere du quiz
  late final String matiere;

  /// Coefficient du quiz
  late final int coefficient;

  /// Quiz d'entrainement ou noté
  late final bool isTraining;

  /// temps en seconde pour une question du quiz
  late final int timerQuiz;

  /// Permet de connaitre le nombre de question qui on été skip pendant la completion du quiz.
  int skipped = 0;

  /// Permet de connaitre le nombre de question qui n'ont pas été répondu avant la fin du timer pendant la completion du quiz.
  int timeout = 0;

  /// Id de l'utilisateur qui a répondu au quiz
  int userId = 0;

  /// Liste des questions du quiz
  late final List<Question> questions;

  /// Date de création du quiz, utilisé pour le nom du fichier json qui le stock.
  late DateTime creationDate = DateTime.now();

  /// Date à laquelle ce quiz a été répondu.
  DateTime answerDate = DateTime.now();

  /// Nom du fichier json qui stock le quiz avec les questions. Stucture = (QuizTraining||QuizGraded)+$id_$creationDateDay-$creationDateMonth-$creationDateYear.json
  late String storageFileName;

  /// Nombre de points total obtenu par les réponses de l'utilisateur au quiz. Utiliser la méthode "computeQuizResult()" pour généré la valeur.
  double result = 0;

  /// Total de bonne réponse de l'utilisateur. Utiliser la méthode "computeQuizResult()" pour généré la valeur.
  int totalCorrectAnswers = 0;

  // Total de mauvaises réponses de l'utilisateur. Utiliser la méthode "computeQuizResult()" pour généré la valeur.
  int totalWrongAnswers = 0;

  /// Permet de valider un non un module de type [ModuleType.quiz] pour la completion du [MainModule].
  bool moduleValidated = false;

  /// Affiche proprement le résultat du quiz sur 20 points.
  String get resultDisplayed => _computeResultDisplayed();
  String _computeResultDisplayed() {
    double resultDisplay = (result / questions.length) * 20;

    // Gère l'affichage des valeurs après la virgules en fonction de la note.
    if (resultDisplay.toString().split('.')[1] == "0") {
      return resultDisplay.toString().split('.')[0];
    } else {
      return resultDisplay.toStringAsFixed(2);
    }
  }

  int get totalTimerMinutes => (timerQuiz * questions.length / 60).round();

  Quiz.fromQuizChangeId(
      {required this.id, required this.answerDate, required Quiz quiz}) {
    quizId = quiz.quizId;
    name = quiz.name;
    niveau = quiz.niveau;
    matiere = quiz.matiere;
    coefficient = quiz.coefficient;
    isTraining = quiz.isTraining;
    timerQuiz = quiz.timerQuiz;
    skipped = quiz.skipped;
    timeout = quiz.timeout;
    userId = quiz.userId;
    questions = quiz.questions;
    creationDate = quiz.creationDate;
    storageFileName = quiz.storageFileName;
    result = quiz.result;
    totalCorrectAnswers = quiz.totalCorrectAnswers;
    totalWrongAnswers = quiz.totalWrongAnswers;

    computeQuizResult();
  }

  Quiz(
      {required this.id,
      required this.quizId,
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

  /// Permet de créer un objet [Quiz] avec un objet [QuizWithoutQuestions] et une liste de [Question] en parametre.
  Quiz.fromQuizWithoutQuestions(
      {required QuizWithoutQuestions quiz, required this.questions}) {
    id = quiz.id;
    quizId = quiz.quizId;
    name = quiz.name;
    niveau = quiz.niveau;
    matiere = quiz.matiere;
    coefficient = quiz.coefficient;
    isTraining = quiz.isTraining;
    timerQuiz = quiz.timerQuiz;
    creationDate = quiz.creationDate;
    storageFileName = quiz.storageFileName;
    computeQuizResult();
  }

  @override
  String toString() {
    return "Quiz n°$id"
        "\n  quizId: $quizId"
        "\n  name: $name"
        "\n  niveau: $niveau"
        "\n  matiere: $matiere"
        "\n  coefficient: $coefficient"
        "\n  isTraining: $isTraining"
        "\n  timerQuiz: $timerQuiz"
        "\n  skipped: $skipped"
        "\n  timeout: $timeout"
        "\n  numberOfQuestions: ${questions.length}";
  }

  /// Calcule les valeurs des parametres [result], [totalCorrectAnswers] et [totalWrongAnswers] en fonction des résultats présents dans la liste des questions.
  void computeQuizResult() {
    result = 0;
    totalCorrectAnswers = 0;
    totalWrongAnswers = 0;
    for (var question in questions) {
      // TODO A modifier si l'on passe en multi réponses un jour.
      if (question.userAnswers[0] == question.correctAnswers[0] &&
              question.correctAnswers[0] == true ||
          question.userAnswers[1] == question.correctAnswers[1] &&
              question.correctAnswers[1] == true ||
          question.userAnswers[2] == question.correctAnswers[2] &&
              question.correctAnswers[2] == true ||
          question.userAnswers[3] == question.correctAnswers[3] &&
              question.correctAnswers[3] == true) {
        result++;
        totalCorrectAnswers++;
      } else if (question.answerTextFromUser != "-1" &&
          question.answerTextFromUser != "-2") {
        totalWrongAnswers++;
      }
    }
  }

  /// Met les valeurs par défaut dans tout les champs de réponse du quiz et de ces questions.
  void resetQuiz() {
    skipped = 0;
    timeout = 0;
    userId = 0;
    answerDate = DateTime.now();
    for (var element in questions) {
      element.resetQuestion();
    }
  }

  /// Calcul les résultats sur 20 des quizs et retourne une validation ou non en fonction du résultat
  /// du meilleur quiz et de la valeur minimum demandé pour la validation [validatingValue]. Permet d'initialisé [Quiz.validated]
  static bool validateQuizModule(List<Quiz> listQuiz, double validatingValue) {
    double bestResult = 0;

    for (var quiz in listQuiz) {
      var quizResult = (quiz.result / quiz.questions.length) * 20;
      if (quizResult > bestResult) bestResult = quizResult;
    }

    return (bestResult >= validatingValue) ? true : false;
  }

  /// Ouvre le quiz qui a été cliqué
  static void navigateAndPlayQuizById(int? quizId, BuildContext context) async {
    if (quizId != null) {
      // Get quiz data
      var quiz = await QuizHandler.getQuizById(quizId);
      // Navigate to Quiz
      if (quiz != null && quiz.isTraining == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlayQuiz(parameterQuiz: quiz)));
      } else {
        debugPrint(
            "Start Quiz Training cancelled (quiz = null), can't navigate.");
      }
    } else {
      debugPrint(
          "Start Quiz Training cancelled (quiz id = null), can't navigate.");
    }
  }

  /// Connect the generated [_$QuizFromJson] function to the `fromJson` factory.
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  /// Connect the generated [_$QuizToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
