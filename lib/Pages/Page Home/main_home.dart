import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/QuizFilters.dart';
import 'package:flutter_food_app/Pages/MainModule&Module/create_mainmodule.dart';
import 'package:flutter_food_app/Pages/MainModule&Module/list_mainmodule.dart';
import 'package:flutter_food_app/Pages/Page%20Home/debug_home.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/create_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/list_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTeacherGrading/list_quiz_graded_to_correct.dart';
import 'package:flutter_food_app/Tools/c_homeCard1.dart';
import '../../utils/dimension.dart';
import '../../utils/uicolors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "Home",
          style: TextStyle(
              color: black,
              fontSize: size18,
              fontFamily: "Saira",
              fontWeight: FontWeight.w400),
        ),
      ),
      body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateQuiz())),
                  },
                  child: c_homeCard1("Créer un quiz", "Sub text",
                      "assets/images/placeholder.png"),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ListQuiz(quizFilters: QuizFilters()))),
                  child: c_homeCard1("Liste des quiz", "Sub text 2",
                      "assets/images/placeholder.png"),
                ),
              ],
            ),
            SizedBox(
              height: size30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateMainModule())),
                  child: c_homeCard1("Créer un module", "Sub text",
                      "assets/images/placeholder.png"),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ListMainModule())),
                  child: c_homeCard1("Liste des modules", "Sub text 2",
                      "assets/images/placeholder.png"),
                ),
              ],
            ),
            SizedBox(
              height: size30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: c_homeCard1("liste note", "Sub text",
                      "assets/images/placeholder.png"),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DebugHome())),
                  child: c_homeCard1("Debug page", "Sub text 2",
                      "assets/images/placeholder.png"),
                ),
              ],
            ),
            SizedBox(
              height: size30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: c_homeCard1("notes par MainModule",
                      "Notes par modules", "assets/images/placeholder.png"),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ListQuizGradedToCorrect())),
                  child: c_homeCard1("Correction prof", "Sub text 2",
                      "assets/images/placeholder.png"),
                ),
              ],
            ),
            SizedBox(
              height: size30,
            ),
          ]),
    );
  }
}
