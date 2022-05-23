import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../Model/QuizQuestion.dart';

class QuestionGradedCard extends StatefulWidget {
  const QuestionGradedCard(
      {Key? key,
      // it means we have to pass this
      required this.question,
      required this.isAnswered,
      required this.callback})
      : super(key: key);

  final Question question;
  final bool isAnswered;
  final Function(String) callback;

  @override
  State<QuestionGradedCard> createState() => _QuestionGradedCardState();
}

class _QuestionGradedCardState extends State<QuestionGradedCard> {
  final userAnswerController = TextEditingController();

  void checkAns(String userResponse) {
    if (widget.isAnswered == false) {
      widget.callback(userResponse);
    }
    // Reset le contenu de champ de texte pour saisir les réponses.
    userAnswerController.text = "";
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
            widget.question.question,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: kBlackColor),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: TextField(
              controller: userAnswerController,
              onChanged: (value) => {
                if (value.length == 2 || value.length == 3) {setState(() {})}
              },
              maxLines: null,
              expands: true,
            ),
          ),
          ElevatedButton(
              onPressed: (userAnswerController.text.length >= 3)
                  ? () => checkAns(userAnswerController.text)
                  : null,
              child: const Text("Valider la réponse")),
        ],
      ),
    );
  }
}
