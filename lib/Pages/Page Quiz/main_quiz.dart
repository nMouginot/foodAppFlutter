import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';
import '../../Model/Quiz.dart';
import '../../constants.dart';
import 'progress_bar.dart';
import 'question_training_card.dart';

class MainQuiz extends StatefulWidget {
  const MainQuiz({Key? key}) : super(key: key);

  @override
  State<MainQuiz> createState() => _MainQuizState();
}

class _MainQuizState extends State<MainQuiz> {
  final int timer = 70; // timer en secondes
  late Quiz currentQuiz;
  late List<Question> questions;
  late Question currentQuestion;
  bool isAnswered = false;
  late void nextQuestion;

  @override
  void initState() {
    List<dynamic> decodedData = jsonDecode(sample_data_quiz);
    currentQuiz = Quiz.fromJson(decodedData.first);
    questions = currentQuiz.questions;
    currentQuestion = questions.first;
    super.initState();
  }

  void _updateTheQuestionIdWithAnswerSelected(int idAnswerSelected) {
    // save si une réponse a été selectionné. Si id = -1, la question a été skip, si id = -2, fin de timer avant réponse.
    // TODO stockage de la réponse en local et en bdd.
    _updateTheQuestionId();
  }

  void _updateTheQuestionId() {
    isAnswered = true;
    setState(() {});

    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestion.id < questions.length) {
        setState(() {
          currentQuestion = questions[currentQuestion.id];
          isAnswered = false;
        });
      } else {
        // TODO affichage fin de QCM et stockage des résultats sur la bdd.
        print("fin de qcm");
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
                      timer: timer,
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
