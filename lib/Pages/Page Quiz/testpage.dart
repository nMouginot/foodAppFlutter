// ignore_for_file: camel_case_types
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/Page Quiz/quiz_handler.dart';
import '../../Model/QuizQuestion.dart';
import '../../Model/Quiz.dart';
import 'package:flutter/services.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

// Uniquement à but de test !
List<QuizWithoutQuestions> generateQuiz() {
  List<QuizWithoutQuestions> listQuiz =
      List<QuizWithoutQuestions>.empty(growable: true);

  listQuiz.add(
    QuizWithoutQuestions(
      id: 1,
      coefficient: 1,
      isTraining: true,
      matiere: "Matiere de test",
      name: "Quiz de test 1",
      niveau: "Débutant",
      timerQuiz: 60,
      creationDate: DateTime.now(),
    ),
  );

  listQuiz.add(
    QuizWithoutQuestions(
      id: 2,
      coefficient: 2,
      isTraining: true,
      matiere: "Matiere de test",
      name: "Quiz de test 2",
      niveau: "Débutant",
      timerQuiz: 60,
      creationDate: DateTime.now(),
    ),
  );
  listQuiz.add(
    QuizWithoutQuestions(
      id: 3,
      coefficient: 1,
      isTraining: true,
      matiere: "Francais",
      name: "Quiz de test 3",
      niveau: "Intermédiaire",
      timerQuiz: 60,
      creationDate: DateTime.now(),
    ),
  );
  listQuiz.add(
    QuizWithoutQuestions(
      id: 4,
      coefficient: 1,
      isTraining: true,
      matiere: "Math",
      name: "Quiz de test 4",
      niveau: "Débutant",
      timerQuiz: 60,
      creationDate: DateTime.now(),
    ),
  );
  return listQuiz;
}

class _testState extends State<test> {
  late AnimationController controller;

// TEST sur UN quiz
  List<Question> listQuestions = Question.generateQuestions(3);
  late Quiz firstTestingQuiz;
  late Question selectedQuestion;

  late String listQuestionsJson;
  late String quizJson;

// TEST SUR UNE LISTE DE QUIZ SANS QUESTIONS
  late List<QuizWithoutQuestions> listQuizData;
  late String listQuizJson;
  late List<QuizWithoutQuestions> decodedListQuiz;

// TEST POUR LES STEAMS !
  Stream<List<QuizWithoutQuestions>> getQuizStream = (() async* {
    await Future<void>.delayed(const Duration(seconds: 2));
    print("${QuizHandler.getQInvValue()}");
    yield await QuizHandler.getQInvValue();
  })();

  @override
  void initState() {
    // #region test
    firstTestingQuiz = Quiz(
        id: 1,
        coefficient: 1,
        isTraining: true,
        matiere: "Matiere de test",
        name: "Quiz de test 1",
        niveau: "Débutant",
        timerQuiz: 60,
        questions: listQuestions);
    listQuestionsJson = jsonEncode(listQuestions);
    quizJson = jsonEncode(firstTestingQuiz);

    // Déserialisation pour 1 quiz
    Map<String, dynamic> mappedData = jsonDecode(quizJson);
    var decodedData = Quiz.fromJson(mappedData);

    // Genere une liste de quiz et l'encode en json.
    listQuizData = generateQuiz();
    listQuizJson = jsonEncode(listQuizData);

    // Déserialisation pour une list de quiz en json
    decodedListQuiz = (jsonDecode(listQuizJson) as List)
        .map((i) => QuizWithoutQuestions.fromJson(i))
        .toList();
    //#endregion

    // Ajoute un quiz dans le fichier json.
    addQuiz();

    super.initState();
  }

  void addQuiz() {
    QuizHandler.addQuizToQinvWithGeneratedId(
        name: "name",
        coefficient: 2,
        creationDate: DateTime.now(),
        isTraining: true,
        matiere: "matiere",
        niveau: "niveau",
        timerQuiz: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => {
                            setState(() => {addQuiz()})
                          },
                      child: const Text("Add new quiz")),
                  ElevatedButton(
                      onPressed: () => {
                            setState(() => {
                                  Clipboard.setData(
                                      ClipboardData(text: listQuizJson))
                                })
                          },
                      child: const Text("Copier le json")),
                  ElevatedButton(
                      onPressed: () => {setState(() => {})},
                      child: const Text("Delete le fichier local des quizs")),
                  // Text(decodedListQuiz.toString()),

                  // STREAM
                  StreamBuilder<List<QuizWithoutQuestions>>(
                    stream: getQuizStream,
                    initialData:
                        List<QuizWithoutQuestions>.empty(growable: true),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<QuizWithoutQuestions>> listQuiz,
                    ) {
                      if (listQuiz.connectionState == ConnectionState.waiting) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [CircularProgressIndicator()]);
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: listQuiz.data?.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text("${listQuiz.data?[index].name}"),
                                  subtitle: Text(
                                      "Matiere: ${listQuiz.data?[index].matiere}\nNiveau: ${listQuiz.data?[index].niveau}"),
                                  onTap: () => {
                                    setState(() => {
                                          listQuiz.data?.removeAt(index),
                                          print("removed $index")
                                        })
                                  },
                                );
                              },
                            )
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
