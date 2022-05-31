import 'package:flutter/material.dart';
import 'package:flutter_food_app/CustomsComponents/body_with_loading.dart';
import 'package:flutter_food_app/CustomsComponents/displayed_timer_by_date.dart';
import 'package:flutter_food_app/CustomsComponents/page_header.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTeacherGrading/correct_quiz.dart';
import 'package:flutter_food_app/Pages/handler_json/user_result_handler.dart';

class ListQuizGradedToCorrect extends StatefulWidget {
  const ListQuizGradedToCorrect({Key? key}) : super(key: key);
  @override
  _ListQuizGradedToCorrectState createState() =>
      _ListQuizGradedToCorrectState();
}

class _ListQuizGradedToCorrectState extends State<ListQuizGradedToCorrect> {
  List<Quiz> listQuizToCorrect = List<Quiz>.empty();
  bool listSetupDone = false;

  @override
  void initState() {
    setupListQuizToCorrect().then((o) {
      setState(() {
        listSetupDone = true;
      });
    });

    super.initState();
  }

  /// Permet de récupérer la liste des Quiz à noté stocker en local
  Future setupListQuizToCorrect() async {
    // TODO {SERVEUR} Mettre à jour le fichier local avec les données du serveur.

    listQuizToCorrect =
        await UserResultHandler.getQuizsToGrade() ?? List<Quiz>.empty();

    print("listQuizToCorrect $listQuizToCorrect");

    if (listQuizToCorrect.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: "Quiz à corriger",
      child: BodyWithLoading(
        isLoading: !listSetupDone,
        child:
            // Si la liste est chargé mais vide, affiche un texte, au sinon, affiche la liste de quiz à corriger.
            (listSetupDone && listQuizToCorrect.isEmpty)
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                        child: Text(
                            "Il n'y a pas de quiz à corriger actuellement.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: "Saira",
                                fontWeight: FontWeight.w400))),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 25),
                    itemCount: listQuizToCorrect.length,
                    itemBuilder: (context, index) {
                      final quizToCorrect = listQuizToCorrect[index];
                      return GestureDetector(
                          onTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CorrectQuiz(quiz: quizToCorrect)))
                              },
                          child: cardListDetails(quizToCorrect));
                    },
                  ),
      ),
    );
  }
}

Card cardListDetails(Quiz quizToCorrect) {
  return Card(
    key: ValueKey(quizToCorrect.id),
    child: ListTile(
      title: Text(quizToCorrect.name),
      subtitle: Text(
          "${quizToCorrect.matiere} - ${quizToCorrect.niveau}  \nQuiz à ${quizToCorrect.questions.length} questions",
          maxLines: 2),
      trailing: DisplayedTimerByDateUpdated(
          maxTimeInHours: 24,
          startTime: quizToCorrect.answerDate,
          duration: const Duration(minutes: 1)),
    ),
  );
}
