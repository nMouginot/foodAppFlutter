import 'package:flutter/material.dart';
import 'package:flutter_food_app/CustomsComponents/cc_text.dart';
import 'package:flutter_food_app/Pages/Page%20Options/main_options.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/create_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/list_training_quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/module_handler.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/quiz_handler.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/testpage.dart';

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
                  builder: (context) => const ListTrainingQuiz()))
            },
            child: ccText("List training quiz"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListTrainingQuiz()))
            },
            child: ccText("List evaluation quiz"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListTrainingQuiz()))
            },
            child: ccText("List quiz to correct"),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListTrainingQuiz()))
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
            onPressed: () => {QuizHandler.getFileJsonTextDebug(10)},
            child: ccText("Content of file"),
          ),
          ElevatedButton(
            onPressed: () => {QuizHandler.deleteFileByIndex(10)},
            child: ccText("Delete file by index"),
          ),
          ElevatedButton(
            onPressed: () => {ModuleHandler.test()},
            child: ccText("Generate Mfile"),
          ),
        ],
      ),
    );
  }
}
