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
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 00, 30, 10),
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
              onChanged: (value) => {
                if (value.length == 2 || value.length == 3) {setState(() {})}
              },
              controller: userAnswerController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 100,
              maxLines: null,
              decoration: InputDecoration(
                  labelText: "Espace de réponse à la question.",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Colors.purple[700] as Color),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Colors.purple[700] as Color),
                    borderRadius: BorderRadius.circular(40),
                  )),
            ),
          ),
          const SizedBox(height: kDefaultPadding / 2),
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
