import 'package:flutter/material.dart';
import 'package:flutter_food_app/CustomsComponents/cc_text.dart';
import 'package:flutter_food_app/Model/QuizFilters.dart';
import 'package:flutter_food_app/Pages/Page%20Options/main_options.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/create_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/list_quiz.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';
import 'package:flutter_food_app/Pages/handler_json/tool_handler.dart';
import 'package:flutter_food_app/Pages/handler_json/user_result_handler.dart';

class DebugHome extends StatefulWidget {
  const DebugHome({Key? key}) : super(key: key);

  @override
  _DebugHomeState createState() => _DebugHomeState();
}

class _DebugHomeState extends State<DebugHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Debug home"),
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
                  builder: (context) => ListQuiz(quizFilters: QuizFilters())))
            },
            child: ccText("List quiz"),
          ),
          ElevatedButton(
            onPressed: () => {},
            child: ccText("List evaluation quiz"),
          ),
          ElevatedButton(
            onPressed: () => {},
            child: ccText("List quiz to correct"),
          ),
          ElevatedButton(
            onPressed: () => {},
            child: ccText("Open payement"),
          ),
          ElevatedButton(
            onPressed: () => {ToolHandler.getAllFileDebug()},
            child: ccText("AFFICHER TOUT LES FICHIER LOCAUX"),
          ),
          ElevatedButton(
            onPressed: () => {ToolHandler.getFileContentDebug(7)},
            child: ccText("CONTENU D'UN FICHIER PAR ID"),
          ),
          ElevatedButton(
            onPressed: () => {QuizHandler.deleteFileByIndex(0)},
            child: ccText("SUPPRESSION D'UN FICHIER PAR ID"),
          ),
          ElevatedButton(
            onPressed: () => {print(UserResultHandler.getQuizResultById(1))},
            child: ccText("get quiz by id"),
          ),
        ],
      ),
    );
  }
}
