import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';

class CreateQuizGradedQuestion extends StatefulWidget {
  const CreateQuizGradedQuestion({Key? key, required this.quizId})
      : super(key: key);

  final int quizId;

  @override
  State<CreateQuizGradedQuestion> createState() =>
      _CreateQuizTrainingQuestionState();
}

class _CreateQuizTrainingQuestionState extends State<CreateQuizGradedQuestion> {
  late List<Question> questionList = List<Question>.empty(growable: true);

  final _formKey = GlobalKey<FormState>();
  final textControllerQuestion = TextEditingController();
  bool isEditing = false;
  Question currentEditedQuestion = Question.generateQuestions(1)[0];

  @override
  void initState() {
    loadingQuizToEdit(widget.quizId);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    textControllerQuestion.dispose();
    super.dispose();
  }

// Vide tous les champs du formulaire de leurs données.
  void cleanForm() {
    textControllerQuestion.text = "";
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
              answersDisplay: "",
              //
              answer1: "",
              answer2: "",
              answer3: "",
              answer4: "",
              answerTextFromUser: "",
              //
              correctAnswers: [],
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
      // Q1 est laissé en placeholder car la fonction "updateQuestionNumbers" vas renommé correctement le début des questions.
      currentEditedQuestion.question = "Q1: ${textControllerQuestion.text}";
      cleanForm();

      Question.updateQuestionNumbers(questionList);
    });
  }

// Permet de charger les données d'une question dans les champs de la page
  void clicEditButton(Question question) {
    setState(() {
      textControllerQuestion.text =
          question.question.split(':')[1].substring(1);
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
//#endregion
}
