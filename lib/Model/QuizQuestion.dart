// ignore_for_file: file_names
import "package:json_annotation/json_annotation.dart";
part "QuizQuestion.g.dart";

// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class Question {
  /// Identifiant unique du quiz
  final int id;

  /// Identifiant permettant de trier l'ordre des questions (Et donc, de les mélangés.) Il est aussi utiliser pour la génération du titre de la question
  int idSorting;

  /// Texte de la question qui est actuellement enregister
  String question;

  /// Première réponse 1 possible à la question.
  String answer1;

  /// Deuxième réponse 2 possible à la question.
  String answer2;
// Troisième réponse 3 possible à la question.
  String answer3;

// Quatrième réponse 4 possible à la question.
  String answer4;

  /// Affichage des réponses dans les blocs sur la page de création de questions.
  String answersDisplay;

  /// Liste de bool permetant de savoir quel question est juste. Toujours une liste de 4 !
  List<bool> correctAnswers;

  /// Pour les quiz noté, permet à l'utilisateur de répondre sans avoir de réponse pré-existante. Si utilisé, answer1/2/3/4 sont vides.
  String answerTextFromUser;

  /// Liste de bool permetant de savoir les réponses de l'utilisateurs. Toujours une liste de 4 !
  List<bool> userAnswers;

  /// Suite de toute les réponses possible sous forme de tableau pour l'affichage des cards sur la page question_training_card
  List<String> get answersGrouped => _computeAnswersGrouped();
  List<String> _computeAnswersGrouped() {
    List<String> result = List.empty(growable: true);

    if (answer1 != "---") {
      result.add(answer1);
    }
    if (answer2 != "---") {
      result.add(answer2);
    }
    if (answer3 != "---") {
      result.add(answer3);
    }
    if (answer4 != "---") {
      result.add(answer4);
    }

    return result;
  }

  /// Liste des bonnes réponse uniquements sous forme de texte pour simplifier les tests de validité.
  List<String> get correctAnswersText => _computeCorrectAnswersTextValue();
  _computeCorrectAnswersTextValue() {
    List<String> result = List.empty(growable: true);
    List<String> allAnswers = List.empty(growable: true);

    if (correctAnswers.isNotEmpty) {
      allAnswers.add(answer1);
    }
    if (correctAnswers.length >= 2) {
      allAnswers.add(answer2);
    }
    if (correctAnswers.length >= 3) {
      allAnswers.add(answer3);
    }
    if (correctAnswers.length >= 4) {
      allAnswers.add(answer4);
    }

    for (var i = 0; i < correctAnswers.length; i++) {
      if (correctAnswers[i] == true) {
        result.add(allAnswers[i]);
      }
    }
    return result;
  }

  Question(
      {required this.id,
      required this.idSorting,
      required this.question,
      required this.answer1,
      required this.answer2,
      required this.answer3,
      required this.answer4,
      required this.answerTextFromUser,
      required this.answersDisplay,
      required this.correctAnswers,
      required this.userAnswers});

  @override
  String toString() {
    return "Question n°$id"
        "\n  idSorting: $idSorting"
        "\n  question: $question"
        "\n  answerTextFromUser: $answerTextFromUser"
        "\n  answersGrouped: $answersGrouped"
        "\n  correctAnswers: $correctAnswers"
        "\n  userAnswers: $userAnswers";
  }

// #region méthodes
  int numberOfAnswers() {
    int result = 0;
    if (answer1.isNotEmpty) result++;
    if (answer2.isNotEmpty) result++;
    if (answer3.isNotEmpty) result++;
    if (answer4.isNotEmpty) result++;
    return result;
  }

  /// Met la valeur par défaut dans tout les champs de réponse utilisateur de la question.
  void resetQuestion() {
    answerTextFromUser = "";
    userAnswers = [false, false, false, false];
  }

  /// Supprime la question [item] de la liste [listItem]
  static void removeItem(List<Question> listItem, Question item) {
    listItem.removeWhere((Question currentItem) => item == currentItem);
    updateQuestionNumbers(listItem);
  }

  /// Génère un nombre de questions équivalent au parametre [numberOfItems]
  static List<Question> generateQuestions(int numberOfItems) {
    return List<Question>.generate(numberOfItems, (int index) {
      return Question(
        id: index,
        idSorting: index + 1,
        question: 'Q${index + 1}: Texte de la question',
        answer1: "Reponse ${index + 1}",
        answer2: "Reponse ${index + 2}",
        answer3: "Reponse ${index + 3}",
        answer4: "Reponse ${index + 4}",
        answerTextFromUser: "",
        answersDisplay:
            "R1: Reponse possible ${index + 1}\nR2: Reponse possible ${index + 2}\nR3: Reponse possible ${index + 3}\nR4: Reponse possible ${index + 4}\n",
        correctAnswers: [false, true, false, false],
        userAnswers: [false, true, false, false],
      );
    });
  }

  static void updateQuestionNumbers(List<Question> listQuestions) {
    for (var i = 0; i < listQuestions.length; i++) {
      // Réatribution des id de tri.
      listQuestions[i].idSorting = i + 1;

      // modification des titres
      listQuestions[i].question =
          "Q${listQuestions[i].idSorting}:${listQuestions[i].question.split(':')[1]}";
    }
  }

  /// Permet d'obtenir un id unique qui n'est pas présent dans la liste [listQuestions]
  static int getNewUniqueId(List<Question> listQuestions) {
    int highestId = 1;

    for (var item in listQuestions) {
      if (item.id >= highestId) {
        highestId = item.id + 1;
      }
    }
    return highestId;
  }

//#endregion

  /// Connect the generated [_$QuestionFromJson] function to the `fromJson` factory.
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  /// Connect the generated [_$QuestionToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
