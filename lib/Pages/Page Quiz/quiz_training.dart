import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';
import '../../Model/Quiz.dart';
import '../../constants.dart';
import 'progress_bar.dart';
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

  @override
  void initState() {
    currentQuiz = widget.parameterQuiz;
    if (currentQuiz.questions.isNotEmpty) {
      currentQuestion = currentQuiz.questions.first;
    } else {
      Navigator.of(context).pop();
    }
    super.initState();
  }

  void _updateTheQuestionIdWithAnswerSelected(int idAnswerSelected) {
    // save si une réponse a été selectionné. Si id = -1, la question a été skip, si id = -2, fin de timer avant réponse.
    // TODO stockage de la réponse en local (et en bdd ? Ou j'attend la fin de quiz ? Pour le training, je pense que la fin de quiz est mieux.)
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
        // TODO affichage fin de QCM et stockage des résultats sur la bdd.
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
