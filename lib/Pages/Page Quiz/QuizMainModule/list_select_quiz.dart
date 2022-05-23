import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/quiz_handler.dart';

class ListSelectQuiz extends StatefulWidget {
  const ListSelectQuiz({Key? key}) : super(key: key);

  @override
  _ListSelectQuizState createState() => _ListSelectQuizState();
}

class _ListSelectQuizState extends State<ListSelectQuiz> {
  void navigationBackWithIdQuiz(QuizWithoutQuestions? quiz) {
    if (quiz != null) {
      Navigator.pop(context, quiz);
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
                    onTap: () =>
                        {navigationBackWithIdQuiz(listQuiz.data?[index])},
                    title: Text("${listQuiz.data?[index].name}"),
                    subtitle: Text(
                        "Matiere: ${listQuiz.data?[index].matiere}\nNiveau: ${listQuiz.data?[index].niveau}"),
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
