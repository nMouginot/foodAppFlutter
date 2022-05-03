import 'package:flutter/material.dart';
import '../../../constants.dart';

class Option extends StatelessWidget {
  const Option(
      {Key? key,
      required this.userAnswer,
      required this.valideAnswers,
      required this.index,
      required this.indexAnswerSelected,
      required this.press,
      required this.answered})
      : super(key: key);
  final String userAnswer;
  final List<String> valideAnswers;
  final int index;
  final int indexAnswerSelected;
  final VoidCallback press;
  final bool answered;

  @override
  Widget build(BuildContext context) {
    Color getTheRightColor() {
      if (answered) {
        // Si la réponse choisi par l'utilisateur est dans la liste des bonnes réponse
        if (valideAnswers.contains(userAnswer)) {
          return kGreenColor;
        } else if (index == indexAnswerSelected &&
            !valideAnswers.contains(userAnswer)) {
          return kRedColor;
        }
        return kGrayColor;
      } else {
        return kGrayColor;
      }
    }

    IconData getTheRightIcon() {
      return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
    }

    return InkWell(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.only(top: kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          border: Border.all(color: getTheRightColor()),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${index + 1}. $userAnswer",
              style: TextStyle(color: getTheRightColor(), fontSize: 16),
            ),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: getTheRightColor() == kGrayColor
                    ? Colors.transparent
                    : getTheRightColor(),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: getTheRightColor()),
              ),
              child: getTheRightColor() == kGrayColor
                  ? null
                  : Icon(getTheRightIcon(), size: 16),
            )
          ],
        ),
      ),
    );
  }
}
