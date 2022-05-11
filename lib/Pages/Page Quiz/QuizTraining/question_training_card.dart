import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../Model/QuizQuestion.dart';
import '../QuizTools/color_question_option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard(
      {Key? key,
      // it means we have to pass this
      required this.question,
      required this.isAnswered,
      required this.callback})
      : super(key: key);

  final Question question;
  final bool isAnswered;
  final Function(int) callback;

  void checkAns(int idSelected) {
    if (isAnswered == false) {
      callback(idSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
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
              press: () => checkAns(index),
            ),
          ),
        ],
      ),
    );
  }
}
