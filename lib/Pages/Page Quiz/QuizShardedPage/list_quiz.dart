import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizFilters.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/play_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/list_quiz_filters.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/create_quiz_training_questions.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';

class ListQuiz extends StatefulWidget {
  ListQuiz({Key? key, required this.quizFilters}) : super(key: key);

  QuizFilters quizFilters;

  @override
  _ListQuizState createState() => _ListQuizState();
}

class _ListQuizState extends State<ListQuiz> {
  // Ouvre le quiz qui a été cliqué
  void navigateToQuizWithData(int? quizId, BuildContext context) async {
    // TODO pop-up a mettre avant la navigation pour confirmer.

    if (quizId != null) {
      // Get quiz data
      var quiz = await QuizHandler.getQuizById(quizId);
      // Navigate to Quiz
      if (quiz != null && quiz.isTraining == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlayQuiz(parameterQuiz: quiz)));
      } else {
        debugPrint("Quiz Training = null, can't navigate.");
      }
    } else {
      debugPrint("Quiz Training Id = null, can't navigate.");
    }
  }

  List<QuizWithoutQuestions> allQuiz =
      List<QuizWithoutQuestions>.empty(growable: true);
  bool allQuizInitialized = false;

  Stream<List<QuizWithoutQuestions>> getQuizStream = (() async* {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    var listQuiz = await QuizHandler.getQInvValue();
    yield listQuiz;
  })();

  Future<bool> removeTrainingQuiz(QuizWithoutQuestions? quizWq) async {
    if (quizWq != null) {
      return await QuizHandler.deleteQuizInQInv(quizWq);
    }
    return false;
  }

  Future<void> _navigateAndGetFilters(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ListQuizFilters(
                quizFilters: widget.quizFilters,
              )),
    );

    setState(() {
      if (result != null) {
        widget.quizFilters = result;
      } else {
        print("FILTRES NULL !!!");
      }
    });
  }

  // Tri les quiz qui peuvent être afficher ou pas en fonction des filtres choisi
  List<QuizWithoutQuestions> sortingQuiz(
      List<QuizWithoutQuestions>? allQuizList) {
    if (allQuizList != null && allQuizList.isNotEmpty) {
      List<QuizWithoutQuestions> sortedQuizList =
          List<QuizWithoutQuestions>.empty(growable: true);

      // Filtre les quiz noté
      if (widget.quizFilters.isGraded) {
        for (var quiz in allQuizList) {
          if (quiz.isTraining == false) {
            sortedQuizList.add(quiz);
          }
        }
      }

      // Filtre les quiz d'entrainement
      if (widget.quizFilters.isTraining) {
        for (var quiz in allQuizList) {
          if (quiz.isTraining == true) {
            sortedQuizList.add(quiz);
          }
        }
      }

      return sortedQuizList;
    } else {
      return List<QuizWithoutQuestions>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Quiz"),
        actions: [
          IconButton(
              onPressed: () => {_navigateAndGetFilters(context)},
              icon: const Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: StreamBuilder<List<QuizWithoutQuestions>>(
        stream: getQuizStream,
        initialData: List<QuizWithoutQuestions>.empty(growable: true),
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
            if (listQuiz.data != null) {
              if (!allQuizInitialized) {
                allQuizInitialized = true;
                allQuiz =
                    (listQuiz.data as List<QuizWithoutQuestions>).toList();
              }
            }
            var sortedListQuiz = sortingQuiz(allQuiz);

            return Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: sortedListQuiz.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      navigateToQuizWithData(sortedListQuiz[index].id, context)
                    },
                    title: Text(sortedListQuiz[index].name),
                    subtitle: Text(
                        "Matiere: ${sortedListQuiz[index].matiere}\nNiveau: ${sortedListQuiz[index].niveau}\n${displayTypeOfQuiz(sortedListQuiz[index].isTraining)}\n"),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateQuizTrainingQuestion(
                                        quizId: sortedListQuiz[index].id)));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (await removeTrainingQuiz(
                                sortedListQuiz[index])) {
                              setState(() => {
                                    allQuiz.remove(sortedListQuiz[index]),
                                    sortedListQuiz.removeAt(index),
                                  });
                            } else {}
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

String displayTypeOfQuiz(bool? isTraining) {
  if (isTraining == null) {
    return "";
  } else {
    if (isTraining) {
      return "Type: Entrainement";
    } else {
      return "Type: Évalué";
    }
  }
}
