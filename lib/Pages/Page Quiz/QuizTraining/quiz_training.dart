import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';
import 'package:flutter_food_app/utils/constants.dart';
import '../../../Model/Quiz.dart';
import '../QuizTools/progress_bar.dart';
import 'question_training_card.dart';

class QuizTraining extends StatefulWidget {
  const QuizTraining({Key? key, required this.parameterQuiz}) : super(key: key);
  final Quiz parameterQuiz;

  @override
  State<QuizTraining> createState() => _QuizTrainingState();
}

class _QuizTrainingState extends State<QuizTraining> {
  late Quiz currentQuiz;
  late Question currentQuestion;
  bool isAnswered = false;
  late void nextQuestion;

  /* Le premier chiffre est le numero de la question, le deuxième est le nombre de point.
    Pour le calcul des points : 
    - Si l'utilisateur a répondu faux, il a 0
    - Si l'utilisateur a répondu a moitié juste, il a 0,5
    - Si l'utilisateur a répondu juste, il a 1
    - Si l'utilisateur a skip la question, -1
    - Si l'utilisateur n'a pas répondu avant la fin du timer, -2

    calcul : Points = réponse justes user / réponses juste totales (Sauf cas spéciaux, timer ou skip.) */
  Map<int, double> userResult = {};

  @override
  void initState() {
    currentQuiz = widget.parameterQuiz;
    if (currentQuiz.questions.isNotEmpty) {
      // TODO Si l'on veut avoir un ordre de question aléatoire, il faut modifier la liste "currentQuiz.questions" ici.

      // Initialise la map des réponses de l'utilisateur.
      for (var i = 0; i < currentQuiz.questions.length; i++) {
        userResult[i + 1] = 0;
      }
      // Défini la première question du quiz.
      currentQuestion = currentQuiz.questions.first;
    } else {
      // Si le quiz n'a pas de question, quitte la page.
      Navigator.of(context).pop();
    }
    super.initState();
  }

  void _updateTheQuestionIdWithAnswerSelected(int idAnswerSelected) {
    // Si id = -1, la question a été skip, si id = -2, fin de timer avant réponse.
    if (idAnswerSelected == -1 || idAnswerSelected == -2) {
      userResult[currentQuestion.id] = idAnswerSelected.toDouble();
    }

    // Fonctionne uniquement avec une seule réponse valide, il faudra modifier ce code avec une boucle si plusieurs réponse sont possibles dans le futur et
    // envoyer une liste en parametre, non pas une réponse unique.
    if (currentQuestion.correctAnswers[idAnswerSelected]) {
      userResult[currentQuestion.id] = 1;
    } else {
      userResult[currentQuestion.id] = 0;
    }
    _updateTheQuestionId();
  }

  void _updateTheQuestionId() {
    isAnswered = true;
    setState(() {});

    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestion.id < currentQuiz.questions.length) {
        setState(() {
          currentQuestion = currentQuiz.questions[currentQuestion.id];
          isAnswered = false;
        });
      } else {
        // Stockage des résultats en local

        // TODO affichage fin de QCM
        // TODO stockage des résultats sur la bdd
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // disable the back button of the app bar
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () => {
                    if (!isAnswered)
                      {_updateTheQuestionIdWithAnswerSelected(-1)}
                  },
              child: const Text("Skip")),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text.rich(
                TextSpan(
                  text: "Question ${currentQuestion.id}/",
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
                child: QuestionCard(
                    question: currentQuestion,
                    isAnswered: isAnswered,
                    callback: _updateTheQuestionIdWithAnswerSelected))
          ],
        ),
      ),
    );
  }
}
