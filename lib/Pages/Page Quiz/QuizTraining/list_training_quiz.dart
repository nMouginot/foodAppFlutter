import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/create_quiz_training_questions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/quiz_handler.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/quiz_training.dart';

class ListTrainingQuiz extends StatefulWidget {
  const ListTrainingQuiz({Key? key}) : super(key: key);

  @override
  _ListTrainingQuizState createState() => _ListTrainingQuizState();
}

class _ListTrainingQuizState extends State<ListTrainingQuiz> {
  void navigateToQuizTrainingWithData(int? quizId, BuildContext context) async {
    if (quizId != null) {
      // Get quiz data
      var quiz = await QuizHandler.getQuizById(quizId);

      // Navigate to QuizTraining
      if (quiz != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuizTraining(
                  parameterQuiz: quiz,
                )));
      } else {
        debugPrint("Quiz Training = null, can't navigate.");
      }
    } else {
      debugPrint("Quiz Training Id = null, can't navigate.");
    }
  }

  Stream<List<QuizWithoutQuestions>> getQuizStream = (() async* {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    yield await QuizHandler.getQInvValue();
  })();

  @override
  Widget build(BuildContext context) {
    Future<bool> removeTrainingQuiz(QuizWithoutQuestions? quizWq) async {
      if (quizWq != null) {
        return await QuizHandler.deleteQuizInQInv(quizWq);
      }
      return false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz d'entrainement")),
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
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listQuiz.data?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => {
                      navigateToQuizTrainingWithData(
                          listQuiz.data?[index].id, context)
                    },
                    title: Text("${listQuiz.data?[index].name}"),
                    subtitle: Text(
                        "Matiere: ${listQuiz.data?[index].matiere}\nNiveau: ${listQuiz.data?[index].niveau}"),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            if (listQuiz.data?[index] != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateQuizQuestion(
                                      quizId:
                                          listQuiz.data?[index].id as int)));
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (await removeTrainingQuiz(
                                listQuiz.data?[index])) {
                              setState(() => {
                                    listQuiz.data?.removeAt(index),
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
