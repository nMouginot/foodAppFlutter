import 'package:flutter/material.dart';
import 'package:flutter_food_app/CustomsComponents/cc_text.dart';
import 'package:flutter_food_app/Pages/Page%20Options/main_options.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/create_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/create_quiz_training_questions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/list_training_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/main_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/quiz_handler.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/testpage.dart';

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
        title: const Text("Home"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainOptions()))
            },
            child: ccText("Open settings page"),
          )),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CreateQuiz()))
            },
            child: ccText("Create quiz"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListTrainingQuiz()))
            },
            child: ccText("List training quiz"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainQuiz()))
            },
            child: ccText("List evaluation quiz"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainQuiz()))
            },
            child: ccText("List quiz to correct"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainQuiz()))
            },
            child: ccText("Open payement"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const test()))
            },
            child: ccText("TEST PAGE"),
          ),
          ElevatedButton(
            onPressed: () => {QuizHandler.getAllFileDebug()},
            child: ccText("Local Files"),
          ),
          ElevatedButton(
            onPressed: () => {QuizHandler.getFileJsonTextDebug(1)},
            child: ccText("Content of file"),
          ),
          ElevatedButton(
            onPressed: () => {QuizHandler.deleteFileByIndex(-1)},
            child: ccText("Delete file by index"),
          ),
        ],
      ),
    );
  }
}
