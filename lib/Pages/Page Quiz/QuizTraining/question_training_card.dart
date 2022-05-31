import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../Model/QuizQuestion.dart';
import '../QuizTools/color_question_option.dart';

class QuestionTrainingCard extends StatelessWidget {
  const QuestionTrainingCard(
      {Key? key,
      required this.question,
      required this.isAnswered,
      required this.callback})
      : super(key: key);

  final Question question;
  final bool isAnswered;
  final Function(String) callback;

  void checkAns(String idSelected) {
    if (isAnswered == false) {
      callback(idSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/images/screen_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              Text(
                question.question,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: kBlackColor),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              ...List.generate(
                question.answersGrouped.length,
                (index) => Option(
                  index: index,
                  userAnswer: question.answersGrouped[index],
                  indexAnswerSelected: index,
                  valideAnswers: question.correctAnswersText,
                  answered: isAnswered,
                  press: () => checkAns((index.toString() + "*")),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
