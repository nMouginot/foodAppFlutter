// ignore_for_file: file_names
import "package:json_annotation/json_annotation.dart";
part "QuizQuestion.g.dart";

// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class Question {
  final int id; // Identifiant unique du quiz
  int idSorting; // Identifiant permettant de trier l'ordre des questions (Et donc, de les mélangés.) Il est aussi utiliser pour la génération du titre de la question
  String question; // Texte de la question qui est actuellement enregister
  String answer1; // Première réponse possible à la question.
  String answer2; // Deuxième réponse possible à la question.
  String answer3; // Troisième réponse possible à la question.
  String answer4; // Quatrième réponse possible à la question.
  String
      answerTextFromUser; // Pour les quiz noté, permet à l'utilisateur de répondre sans avoir de réponse pré-existante. Si utilisé, answer1/2/3/4 sont vides.
  String
      answersDisplay; // Affichage des réponses dans les blocs sur la page de création de questions.
  List<bool>
      correctAnswers; // Liste de bool permetant de savoir quel question est juste. Toujours une liste de 4 normalement !

  // Suite de toute les réponses possible sous forme de tableau pour l'afficahge des cards sur la page question_training_card
  List<String> get answersGrouped => [answer1, answer2, answer3, answer4];

// Liste des bonnes réponse uniquements sous forme de texte pour simplifier les tests de validité.
  List<String> get correctAnswersText => _computeCorrectAnswersTextValue();
  _computeCorrectAnswersTextValue() {
    List<String> result = List.empty(growable: true);
    switch (correctAnswers.length) {
      case 4:
        result.add(answer4);
        continue case3;

      case3:
      case 3:
        result.add(answer3);
        continue case2;

      case2:
      case 2:
        result.add(answer2);
        continue case1;

      case1:
      case 1:
        result.add(answer1);
        break;
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
      required this.correctAnswers});

// #region méthodes
  int numberOfAnswers() {
    int result = 0;
    if (answer1.isNotEmpty) result++;
    if (answer2.isNotEmpty) result++;
    if (answer3.isNotEmpty) result++;
    if (answer4.isNotEmpty) result++;
    return result;
  }

  static void removeItem(List<Question> listItem, Question item) {
    listItem.removeWhere((Question currentItem) => item == currentItem);
    updateQuestionNumbers(listItem);
  }

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

// ignore: constant_identifier_names
const String sample_data_quizQuestionOLD = """[
  {
    "id": 1,
    "question":
        "Flutter is an open-source UI software development kit created by ______",
    "answers": ["Apple", "Google", "Facebook", "Microsoft"],
    "validAnswers": ["Apple"]
  },
  {
    "id": 2,
    "question": "When google release Flutter.",
    "answers": ["Jun 2017", "Jun 2017", "May 2017", "May 2018"],
    "validAnswers": ["May 2017"]
  },
  {
    "id": 3,
    "question": "A memory location that holds a single letter or number.",
    "answers": ["Double", "Int", "Char", "Word"],
    "validAnswers": ["Char"]
  },
  {
    "id": 4,
    "question": "What command do you use to output data to the screen?",
    "answers": ["Cin", "Count>>", "Cout", "Output>>"],
    "validAnswers": ["Cout"]
  }
]""";
