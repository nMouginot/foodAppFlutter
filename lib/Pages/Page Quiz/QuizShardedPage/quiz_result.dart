import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/strings.dart';
import 'package:flutter_food_app/utils/uicolors.dart';
import 'package:flutter_svg/svg.dart';

class QuizResult extends StatefulWidget {
  const QuizResult({Key? key, required this.quizUserResult}) : super(key: key);

  final Quiz quizUserResult;

  @override
  _QuizResultState createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {
  @override
  void initState() {
    // Compte les réponses justes.
    widget.quizUserResult.computeQuizResult();

    // TODO Stockage des résultats en local (plutôt sur la page de résult ?)
    // TODO stockage des résultats sur la bdd (plutôt sur la page de résult ?)
    // TODO Save les données !  => widget.userResult a parse json et stocker

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints view) {
      Stack ansData(String name, var icon, bool active) {
        return Stack(children: [
          Container(
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
          ),
          Visibility(
            visible: !active,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size30),
              color: Colors.blueGrey.withAlpha(140),
              width: double.infinity,
              height: size52,
            ),
          ),
        ]);
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
                  widget.quizUserResult.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: grey13,
                      fontSize: size18,
                      fontFamily: "Saira",
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: size70,
                ),
                Visibility(
                  visible: widget.quizUserResult.isTraining,
                  child: Text(
                    "${widget.quizUserResult.resultDisplayed}/20",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: size60,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: !widget.quizUserResult.isTraining,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 00, 20, 00),
                      child: Text(
                        "Vos réponses ont été envoyé à un professeur pour la correction, les résultats serons disponible dans un délai de 24H.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: grey13,
                            fontSize: size18,
                            fontFamily: "Saira",
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // #region réponse à évaluer
                    Visibility(
                      visible: !widget.quizUserResult.isTraining,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        height: size40,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          color: blue11.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(size30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/clock.svg",
                              color: Colors.green[800],
                              width: size16,
                              height: size16,
                            ),
                            SizedBox(
                              width: size10,
                            ),
                            Text(
                              "${widget.quizUserResult.questions.length - (widget.quizUserResult.skipped + widget.quizUserResult.timeout)} réponses à évaluer",
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
                    ),
                    //#endregion
                    // #region réponse correct
                    Visibility(
                      visible: widget.quizUserResult.isTraining,
                      child: Container(
                        width: size130,
                        height: size40,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          color: blue11.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(size30)),
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
                              "${widget.quizUserResult.totalCorrectAnswers} $correctText",
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
                    ),
                    //#endregion
                    // #region failed
                    Visibility(
                      visible: widget.quizUserResult.isTraining,
                      child: SizedBox(
                        width: size20,
                      ),
                    ),
                    Visibility(
                      visible: widget.quizUserResult.isTraining,
                      child: Container(
                        width: size130,
                        height: size40,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          color: blue11.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(size30)),
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
                              "${widget.quizUserResult.totalWrongAnswers} $wrongText",
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
                    )
                    //#endregion
                  ],
                ),
                SizedBox(
                  height: size10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // #region réponse Timeout
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            "${widget.quizUserResult.timeout}Timeout",
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
                    //#endregion
                    SizedBox(
                      width: size50,
                    ),
                    // #region réponse Skipped
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                            "${widget.quizUserResult.skipped} Skipped",
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
                    //#endregion
                  ],
                ),
                SizedBox(
                  height: size60,
                ),
                ansData("Partager", "assets/images/icons/share.png", false),
                SizedBox(
                  height: size20,
                ),
                ansData(
                    "Recommencer",
                    "assets/images/icons/forword_arrow_1.png",
                    widget.quizUserResult.isTraining),
                SizedBox(
                  height: size20,
                ),
                GestureDetector(
                    onTap: () => Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName)),
                    child: ansData("Retour",
                        "assets/images/icons/back_arrow_1.png", true)),
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
