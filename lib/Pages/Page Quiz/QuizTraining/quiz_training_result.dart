import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/strings.dart';
import 'package:flutter_food_app/utils/uicolors.dart';
import 'package:flutter_svg/svg.dart';

class QuizTrainingResult extends StatefulWidget {
  const QuizTrainingResult(
      {Key? key, required this.quizName, required this.userResult})
      : super(key: key);

  final String quizName;
  final Map<int, double> userResult;

  @override
  _QuizTrainingResultState createState() => _QuizTrainingResultState();
}

class _QuizTrainingResultState extends State<QuizTrainingResult> {
  double result = 0;
  String resultDisplayed = "";
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int timerEnd = 0;
  int skipped = 0;

  @override
  void initState() {
    widget.userResult.forEach((key, value) {
      // Vérifie que la valeur est bien un score. (-1 et -2 sont utiliser en cas de fin de timer ou de skip)
      if (value >= 0 && value <= 1) {
        // Compte les bonnes réponses (score >= 0.5)
        if (value >= 0.5) correctAnswers++;

        // Compte les mauvaises réponses (score < 0.5)
        if (value < 0.5) wrongAnswers++;

        // Compte le total de points gagné
        result += value;
      } else {
        // Compte les questions skip (-1)
        if (value == -1) skipped++;

        // Compte les questions en fin de timer (-2)
        if (value == -2) timerEnd++;
      }
    });

    result = (result / widget.userResult.length) * 20;

    // Gère l'affichage des valeurs après la virgules en fonction de la note.
    if (result.toString().split('.')[1] == "0") {
      resultDisplayed = result.toString().split('.')[0];
    } else {
      resultDisplayed = result.toStringAsFixed(2);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints view) {
      Container ansData(String name, var icon) {
        return Container(
          width: view.maxWidth,
          height: size52,
          alignment: AlignmentDirectional.center,
          margin: EdgeInsets.symmetric(horizontal: size30),
          decoration: BoxDecoration(
            color: blue11,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.only(left: size90),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: white,
                        fontSize: size18,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: EdgeInsets.only(right: size10),
                  child: Image.asset(
                    icon,
                    width: size24,
                    height: size22,
                    color: white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              width: view.maxWidth,
              height: view.maxHeight,
              child: Image.asset(
                "assets/images/screen_bg.png",
                fit: BoxFit.cover,
              ),
            ),
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: size50),
              children: [
                Padding(
                  padding: EdgeInsets.only(right: size50, top: size50),
                ),
                Text(
                  congratulationsText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: grey13,
                      fontSize: size35,
                      fontFamily: "Saira",
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size5,
                ),
                Text(
                  successfullyText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: grey13,
                      fontSize: size16,
                      fontFamily: "Saira",
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: size5,
                ),
                Text(
                  widget.quizName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: grey13,
                      fontSize: size18,
                      fontFamily: "Saira",
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size60,
                ),
                Text(
                  "$resultDisplayed/20",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: size60,
                      fontFamily: "Saira",
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size130,
                      height: size40,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: blue11.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(size30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icons/done_1.png",
                            width: size16,
                            height: size16,
                          ),
                          SizedBox(
                            width: size10,
                          ),
                          Text(
                            "$correctAnswers $correctText",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: black,
                                fontSize: size16,
                                fontFamily: "Saira",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size20,
                    ),
                    Container(
                      width: size130,
                      height: size40,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: blue11.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(size30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icons/failed.png",
                            width: size16,
                            height: size16,
                          ),
                          SizedBox(
                            width: size10,
                          ),
                          Text(
                            "$wrongAnswers $wrongText",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: black,
                                fontSize: size16,
                                fontFamily: "Saira",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size130,
                      height: size40,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: blue11.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(size30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/clock.svg",
                            color: red,
                            width: size16,
                            height: size16,
                          ),
                          SizedBox(
                            width: size10,
                          ),
                          Text(
                            "$timerEnd Timeout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: black,
                                fontSize: size16,
                                fontFamily: "Saira",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size50,
                    ),
                    Container(
                      width: size130,
                      height: size40,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: blue11.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(size30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icons/forword_arrow_1.png",
                            color: red,
                            width: size16,
                            height: size16,
                          ),
                          SizedBox(
                            width: size10,
                          ),
                          Text(
                            "$skipped Skipped",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: black,
                                fontSize: size16,
                                fontFamily: "Saira",
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size30,
                ),
                ansData("Partager", "assets/images/icons/share.png"),
                SizedBox(
                  height: size20,
                ),
                ansData(
                    "Recommencer", "assets/images/icons/forword_arrow_1.png"),
                SizedBox(
                  height: size20,
                ),
                GestureDetector(
                    onTap: () => Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName)),
                    child: ansData(
                        "Retour", "assets/images/icons/back_arrow_1.png")),
                SizedBox(
                  height: size20,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
