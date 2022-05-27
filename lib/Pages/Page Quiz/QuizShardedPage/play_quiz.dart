import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/quiz_result.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/question_training_card.dart';
import 'package:flutter_food_app/utils/constants.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/uicolors.dart';
import '../../../Model/Quiz.dart';
import '../QuizTools/progress_bar.dart';
import '../QuizGraded/question_graded_card.dart';

class PlayQuiz extends StatefulWidget {
  const PlayQuiz({Key? key, required this.parameterQuiz}) : super(key: key);
  final Quiz parameterQuiz;

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  late Quiz currentQuiz;
  late Question currentQuestion;
  bool isAnswered = false;
  late void nextQuestion;

  @override
  void initState() {
    currentQuiz = widget.parameterQuiz;
    currentQuiz.resetQuiz();
    if (currentQuiz.questions.isNotEmpty) {
      for (var i = 0; i < currentQuiz.questions.length; i++) {
        // TODO Si l'on veut avoir un ordre de question aléatoire, il faut modifier les valeurs "currentQuiz.questions.idSorting" ici.
        // Tri le quiz dans un ordre fixe. A modifier pour avoir un ordre variable !
        currentQuiz.questions[i].idSorting = i + 1;
      }
      // Défini la première question du quiz.
      currentQuestion = currentQuiz.questions.first;
    } else {
      // Si le quiz n'a pas de question, quitte la page.
      debugPrint(
          "Erreur lors de la navigation sur le quiz. Les questions sont vides.");
      Navigator.of(context).pop();
    }
    super.initState();
  }

  void _updateTheQuestionId() {
    isAnswered = true;
    setState(() {}); // Affiche les résultats à la question du quiz.
    int pauseDuration = 0;
    if (currentQuiz.isTraining) pauseDuration = 2;

    Future.delayed(Duration(seconds: pauseDuration), () {
      if (currentQuestion.idSorting < currentQuiz.questions.length) {
        setState(() {
          currentQuestion = currentQuiz.questions[currentQuestion.idSorting];
          isAnswered = false;
        });
      } else {
        // Navigation sur la page de résultat
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuizResult(quizUserResult: currentQuiz)));
      }
    });
  }

  void _updateTheQuestionIdWithAnswerSelected(String response) {
    currentQuestion.answerTextFromUser = response;

    // Si question.answerTextFromUser = -1, la question a été passé (skip), si question.answerTextFromUser = -2, fin de timer avant réponse (timeout).
    if (response == "-1") {
      currentQuiz.skipped++;
    } else if (response == "-2") {
      currentQuiz.timeout++;
    } else {
      if (response.contains("0*")) currentQuestion.userAnswers[0] = true;
      if (response.contains("1*")) currentQuestion.userAnswers[1] = true;
      if (response.contains("2*")) currentQuestion.userAnswers[2] = true;
      if (response.contains("3*")) currentQuestion.userAnswers[3] = true;
    }

    _updateTheQuestionId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 5.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "Quiz",
          style: TextStyle(
              color: black,
              fontSize: size18,
              fontFamily: "Saira",
              fontWeight: FontWeight.w400),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.purple[700]),
                onPressed: () => {
                      if (!isAnswered)
                        {_updateTheQuestionIdWithAnswerSelected("-1")}
                    },
                child: const Text("Skip")),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/screen_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Visibility(
                      visible: !isAnswered,
                      child: ProgressBar(
                          key: UniqueKey(),
                          timer: currentQuiz.timerQuiz,
                          callback: _updateTheQuestionIdWithAnswerSelected),
                    )),
                const SizedBox(height: kDefaultPadding),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Text.rich(
                    TextSpan(
                      text: "Question ${currentQuestion.idSorting}/",
                      style: Theme.of(context).textTheme.headline4,
                      children: [
                        TextSpan(
                            text: "${currentQuiz.questions.length}",
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1.5),
                const SizedBox(height: kDefaultPadding),
                Expanded(
                  child: (currentQuiz.isTraining)
                      ? QuestionTrainingCard(
                          question: currentQuestion,
                          isAnswered: isAnswered,
                          callback: _updateTheQuestionIdWithAnswerSelected)
                      : QuestionGradedCard(
                          question: currentQuestion,
                          isAnswered: isAnswered,
                          callback: _updateTheQuestionIdWithAnswerSelected),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
