import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';

class CreateQuizTrainingQuestion extends StatefulWidget {
  const CreateQuizTrainingQuestion({Key? key, required this.quizId})
      : super(key: key);

  final int quizId;

  @override
  State<CreateQuizTrainingQuestion> createState() =>
      _CreateQuizTrainingQuestionState();
}

class _CreateQuizTrainingQuestionState
    extends State<CreateQuizTrainingQuestion> {
  late List<Question> questionList = List<Question>.empty(growable: true);

  final _formKey = GlobalKey<FormState>();
  final textControllerQuestion = TextEditingController();
  final textControllerAnswer1 = TextEditingController();
  final textControllerAnswer2 = TextEditingController();
  final textControllerAnswer3 = TextEditingController();
  final textControllerAnswer4 = TextEditingController();
  bool visibilityAnswer3 = false;
  bool visibilityAnswer4 = false;
  bool isEditing = false;
  Question currentEditedQuestion = Question.generateQuestions(1)[0];
  bool correctAnswer1 = false;
  bool correctAnswer2 = false;
  bool correctAnswer3 = false;
  bool correctAnswer4 = false;

  @override
  void initState() {
    loadingQuizToEdit(widget.quizId);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    textControllerQuestion.dispose();
    textControllerAnswer1.dispose();
    textControllerAnswer2.dispose();
    textControllerAnswer3.dispose();
    textControllerAnswer4.dispose();
    super.dispose();
  }

// Vide tous les champs du formulaire de leurs données.
  void cleanForm() {
    textControllerQuestion.text = "";
    textControllerAnswer1.text = "";
    textControllerAnswer2.text = "";
    textControllerAnswer3.text = "";
    textControllerAnswer4.text = "";
    visibilityAnswer3 = false;
    visibilityAnswer4 = false;
    correctAnswer1 = false;
    correctAnswer2 = false;
    correctAnswer3 = false;
    correctAnswer4 = false;
  }

// Ajoute une nouvelle question à la liste : questionList
  void addNewQuestion() {
    if (_formKey.currentState!.validate()) {
      setState(
        () {
          questionList.add(
            Question(
              id: Question.getNewUniqueId(questionList),
              idSorting: questionList.length + 1,
              question:
                  "Q${questionList.length + 1}: ${textControllerQuestion.text}",
              //
              answersDisplay: // √ est le symbole pour la racine carré :D (alt code = 251)
                  "${(correctAnswer1) ? "√" : "  "} R1: ${(textControllerAnswer1.text.isNotEmpty) ? textControllerAnswer1.text : "---"}\n"
                  "${(correctAnswer2) ? "√" : "  "} R2: ${(textControllerAnswer2.text.isNotEmpty) ? textControllerAnswer2.text : "---"}\n"
                  "${(correctAnswer3) ? "√" : "  "} R3: ${(textControllerAnswer3.text.isNotEmpty) ? textControllerAnswer3.text : "---"}\n"
                  "${(correctAnswer4) ? "√" : "  "} R4: ${(textControllerAnswer4.text.isNotEmpty) ? textControllerAnswer4.text : "---"}",
              //
              answer1: (textControllerAnswer1.text.isNotEmpty)
                  ? textControllerAnswer1.text
                  : "---",
              answer2: (textControllerAnswer2.text.isNotEmpty)
                  ? textControllerAnswer2.text
                  : "---",
              answer3: (textControllerAnswer3.text.isNotEmpty)
                  ? textControllerAnswer3.text
                  : "---",
              answer4: (textControllerAnswer4.text.isNotEmpty)
                  ? textControllerAnswer4.text
                  : "---",
              answerTextFromUser: "",
              //
              correctAnswers: [
                correctAnswer1,
                correctAnswer2,
                correctAnswer3,
                correctAnswer4
              ],
              userAnswers: [],
            ),
          );

          cleanForm();
        },
      );
    }
  }

// Permet de modifier une question via le formulaire.
  void editQuestion() {
    setState(() {
      isEditing = false;

      currentEditedQuestion.question = "Q1: ${textControllerQuestion.text}";

      currentEditedQuestion.answersDisplay =
          "${(correctAnswer1) ? "√" : "  "} R1: ${(textControllerAnswer1.text.isNotEmpty) ? textControllerAnswer1.text : "---"}\n"
          "${(correctAnswer2) ? "√" : "  "} R2: ${(textControllerAnswer2.text.isNotEmpty) ? textControllerAnswer2.text : "---"}\n"
          "${(correctAnswer3) ? "√" : "  "} R3: ${(textControllerAnswer3.text.isNotEmpty) ? textControllerAnswer3.text : "---"}\n"
          "${(correctAnswer4) ? "√" : "  "} R4: ${(textControllerAnswer4.text.isNotEmpty) ? textControllerAnswer4.text : "---"}";

      currentEditedQuestion.answer1 = (textControllerAnswer1.text.isNotEmpty)
          ? textControllerAnswer1.text
          : "---";
      currentEditedQuestion.answer2 = (textControllerAnswer2.text.isNotEmpty)
          ? textControllerAnswer2.text
          : "---";
      currentEditedQuestion.answer3 = (textControllerAnswer3.text.isNotEmpty)
          ? textControllerAnswer3.text
          : "---";
      currentEditedQuestion.answer4 = (textControllerAnswer4.text.isNotEmpty)
          ? textControllerAnswer4.text
          : "---";

      currentEditedQuestion.correctAnswers = [
        correctAnswer1,
        correctAnswer2,
        correctAnswer3,
        correctAnswer4
      ];

      cleanForm();
      Question.updateQuestionNumbers(questionList);
    });
  }

// Permet de charger les données d'une question dans les champs de la page
  void clicEditButton(Question question) {
    setState(() {
      textControllerQuestion.text =
          question.question.split(':')[1].substring(1);
      textControllerAnswer1.text =
          (question.answer1 != "---") ? question.answer1 : "";
      textControllerAnswer2.text =
          (question.answer2 != "---") ? question.answer2 : "";
      textControllerAnswer3.text =
          (question.answer3 != "---") ? question.answer3 : "";
      textControllerAnswer4.text =
          (question.answer4 != "---") ? question.answer4 : "";

      correctAnswer1 = question.correctAnswers[0];
      correctAnswer2 = question.correctAnswers[1];
      correctAnswer3 = question.correctAnswers[2];
      correctAnswer4 = question.correctAnswers[3];

      if (textControllerAnswer2.text.isNotEmpty ||
          textControllerAnswer3.text.isNotEmpty) {
        visibilityAnswer3 = true;
      } else {
        visibilityAnswer3 = false;
      }

      if (textControllerAnswer4.text.isNotEmpty) {
        visibilityAnswer4 = true;
      } else {
        visibilityAnswer4 = false;
      }

      isEditing = true;
      currentEditedQuestion = question;
    });
  }

  void loadingQuizToEdit(int quizId) async {
    Quiz? quizValue = await QuizHandler.getQuizById(quizId);
    if (quizValue != null) {
      Quiz quiz = quizValue;

      setState(() {
        questionList = quiz.questions;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future<bool> validateAndSaveQuiz(int p_quizId) async {
    late final int quizId;
    late final QuizWithoutQuestions quizInfoValidated;

    // Si c'est un quiz qui est existant nulpart. (Pas dans le fichier QInv)
    if (p_quizId < 0) {
      // Si l'on passe ici, c'est que l'on modifie les questions d'un quiz qui n'existe pas. ERREUR CRITIQUE !
      debugPrint(
          "ERREUR : Tentative de modification des questions d'un quiz qui n'existe pas !");
    } else {
      quizId = p_quizId;

      // Si c'est un quiz existant avec ou sans fichier json, je vérifie qu'il est bien dans QInv et je récup ces valeurs.
      if (await QuizHandler.getQuizWithoutQuestionsById(quizId) != null) {
        quizInfoValidated =
            await QuizHandler.getQuizWithoutQuestionsById(quizId)
                as QuizWithoutQuestions;
      } else {
        throw Exception(
            "Erreur, le quiz en tentative de modification de question n'est pas existant dans QInv");
      }
    }

    Quiz quizToAdd = Quiz(
      id: quizId,
      name: quizInfoValidated.name,
      coefficient: quizInfoValidated.coefficient,
      isTraining: quizInfoValidated.isTraining,
      matiere: quizInfoValidated.matiere,
      niveau: quizInfoValidated.niveau,
      timerQuiz: quizInfoValidated.timerQuiz,
      questions: questionList,
    );

    QuizHandler.addQuiz(quizToAdd);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await validateAndSaveQuiz(widget.quizId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Créer un quiz")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                        onChanged: (e) => setState(() {}),
                        controller: textControllerQuestion,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Question'),
                        validator: validatorQuizQuestion),
                    Visibility(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                onChanged: (e) => setState(() {}),
                                controller: textControllerAnswer1,
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Réponse possible 1'),
                                validator: validatorQuizReponse1),
                          ),
                          Checkbox(
                              value: correctAnswer1,
                              onChanged: (value) => setState(() {
                                    correctAnswer1 = !correctAnswer1;
                                  }))
                        ],
                      ),
                    ),
                    Visibility(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                controller: textControllerAnswer2,
                                onChanged: (value) => {
                                      setState(
                                        () {
                                          (value.isNotEmpty)
                                              ? visibilityAnswer3 = true
                                              : visibilityAnswer3 = false;
                                        },
                                      )
                                    },
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Réponse possible 2'),
                                validator: validatorQuizReponse2),
                          ),
                          Checkbox(
                              value: correctAnswer2,
                              onChanged: (value) => setState(() {
                                    correctAnswer2 = !correctAnswer2;
                                  }))
                        ],
                      ),
                    ),
                    Visibility(
                      visible: visibilityAnswer3,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textControllerAnswer3,
                              onChanged: (value) => {
                                setState(
                                  () {
                                    (value.isNotEmpty)
                                        ? visibilityAnswer4 = true
                                        : visibilityAnswer4 = false;
                                  },
                                )
                              },
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Réponse possible 3'),
                            ),
                          ),
                          Checkbox(
                              value: correctAnswer3,
                              onChanged: (value) => setState(() {
                                    correctAnswer3 = !correctAnswer3;
                                  }))
                        ],
                      ),
                    ),
                    Visibility(
                      visible: visibilityAnswer4,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textControllerAnswer4,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Réponse possible 4'),
                            ),
                          ),
                          Checkbox(
                              value: correctAnswer4,
                              onChanged: (value) => setState(() {
                                    correctAnswer4 = !correctAnswer4;
                                  }))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              child: const Text("Ajouter la question"),
                              onPressed: (isEditing)
                                  ? null
                                  : () => {addNewQuestion()}),
                          ElevatedButton(
                            child: Text(
                                "Modifier la question Q${currentEditedQuestion.idSorting}"),
                            onPressed:
                                (!isEditing) ? null : () => {editQuestion()},
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              _buildPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 2,
      children: questionList.map<ExpansionPanelRadio>((Question question) {
        return ExpansionPanelRadio(
            value: question.id,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                  title: Text(question.question),
                  trailing: const Icon(Icons.delete, size: 30),
                  onTap: () {
                    setState(() {
                      Question.removeItem(questionList, question);
                    });
                  });
            },
            body: ListTile(
                title: Text(question.answersDisplay),
                subtitle: const Text(
                    'To delete this question, tap the trash can icon, to edit it, tap on the pen.'), // TODO TRADUCTION
                trailing: const Icon(
                  Icons.edit,
                  size: 30,
                ),
                onTap: () {
                  clicEditButton(question);
                }));
      }).toList(),
    );
  }

  //#region Validator
  String? validatorQuizQuestion(String? value) {
    if (value == null || value.isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  String? validatorQuizReponse1(String? value) {
    if (value == null || value.isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  String? validatorQuizReponse2(String? value) {
    if (value == null || value.isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }
//#endregion
}
