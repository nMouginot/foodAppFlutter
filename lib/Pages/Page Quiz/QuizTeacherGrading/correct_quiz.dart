import 'package:flutter/material.dart';
import 'package:flutter_food_app/CustomsComponents/page_header.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/Model/QuizQuestion.dart';

class CorrectQuiz extends StatefulWidget {
  const CorrectQuiz({Key? key, required this.quiz}) : super(key: key);

  final Quiz quiz;

  @override
  _CorrectQuizState createState() => _CorrectQuizState();
}

class _CorrectQuizState extends State<CorrectQuiz> {
  double result = 0;
  String resultDisplay = "";

  @override
  void initState() {
    // TODO: implement initState
    _computeResultDisplay();
    super.initState();
  }

  int _computeResultDisplay() {
    result = 0;
    for (var question in widget.quiz.questions) {
      result += question.result;
    }
    var resultOnTwenty = (result / widget.quiz.questions.length) * 20;

    setState(() {
      // Gère l'affichage des valeurs après la virgules en fonction de la note.
      if (resultOnTwenty.toString().split('.')[1] == "0") {
        resultDisplay = resultOnTwenty.toString().split('.')[0];
      } else {
        resultDisplay = resultOnTwenty.toStringAsFixed(2);
      }
    });
    return resultOnTwenty.round();
  }

  void _checkButtonValidation() {
    setState(() {});
  }

  void Function()? validateQuizCorrection() {
    for (var question in widget.quiz.questions) {
      if (question.result < 1 && question.correctorCommentary.length < 5) {
        return null;
      }
      if (question.result < 0) {
        return null;
      }
      if (question.result == 1) {
        question.correctorCommentary = "";
      }
    }
    return () => {
          widget.quiz.moduleGraded = true,
          widget.quiz.moduleValidated = (_computeResultDisplay() >= 10),
          // TODO {SERVEUR} Enregister le résultat côté serveur
          // TODO Enregister le résultat en local
        };
  }

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: "Correction : ${widget.quiz.name}",
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
              itemCount: widget.quiz.questions.length,
              itemBuilder: (context, index) {
                final question = widget.quiz.questions[index];
                return cardListDetails(
                    question: question,
                    updateDisplayedResult: _computeResultDisplay,
                    checkButtonValidation: _checkButtonValidation);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text("$resultDisplay/20",
                  style: TextStyle(
                      color: Colors.blueGrey[500],
                      fontSize: 40,
                      fontFamily: "Saira",
                      fontWeight: FontWeight.w400)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[800],
                ),
                onPressed: validateQuizCorrection(),
                child: const Text("Valider la correction")),
          ],
        ),
      ),
    );
  }
}

//#region cardListDetails

// ignore: camel_case_types
class cardListDetails extends StatefulWidget {
  const cardListDetails(
      {Key? key,
      required this.question,
      required this.updateDisplayedResult,
      required this.checkButtonValidation})
      : super(key: key);

  final Question question;
  final void Function() updateDisplayedResult;
  final void Function() checkButtonValidation;

  @override
  _CardListDetailsState createState() => _CardListDetailsState();
}

class _CardListDetailsState extends State<cardListDetails> {
  TextEditingController correctorCommentary = TextEditingController();
  int buttonSelected = 0;
  Color? buttonBaseColor = Colors.purple[500];
  Color? buttonGoodColor = Colors.green[300];
  Color? buttonMediumColor = Colors.orange[900];
  Color? buttonBadColor = Colors.red[900];

  void changeButtonSelected(int newValue) {
    switch (newValue) {
      case 1:
        widget.question.result = 0;
        break;
      case 2:
        widget.question.result = 0.5;
        break;
      case 3:
        widget.question.result = 1;
        break;
    }

    widget.updateDisplayedResult();

    setState(() {
      buttonSelected = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    var question = widget.question;
    return Column(
      children: [
        Card(
            color: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.all(10),
            key: ValueKey(question.id),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(question.question,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 5,
                ),
                Text(question.answerTextFromUser,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: 20,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: (buttonSelected == 1)
                                ? buttonBadColor
                                : buttonBaseColor),
                        onPressed: () => changeButtonSelected(1),
                        child: const Text("0")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: (buttonSelected == 2)
                                ? buttonMediumColor
                                : buttonBaseColor),
                        onPressed: () => changeButtonSelected(2),
                        child: const Text("0,5")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: (buttonSelected == 3)
                                ? buttonGoodColor
                                : buttonBaseColor),
                        onPressed: () => changeButtonSelected(3),
                        child: const Text("1")),
                  ],
                ),
                Visibility(
                  visible: (widget.question.result < 1 &&
                      widget.question.result >= 0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) => {
                        widget.question.correctorCommentary =
                            correctorCommentary.text,
                        widget.checkButtonValidation()
                      },
                      controller: correctorCommentary,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 3,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Indiquer les elements manquants.",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.purple[700] as Color),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.purple[200] as Color),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
//#endregions
