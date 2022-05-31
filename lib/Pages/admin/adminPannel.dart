// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/create_quiz.dart';

import '../coursPDF/add_cours.dart';
import 'adminListCoursPdf.dart';

class AdminPannel extends StatefulWidget {
  const AdminPannel({Key? key}) : super(key: key);

  @override
  _AdminPannelState createState() => _AdminPannelState();
}

class _AdminPannelState extends State<AdminPannel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrateur'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            buttonInfiniteWidth("Liste des utilisateurs"),
            buttonInfiniteWidth(
                "Liste des cours",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDisplayCoursPdf(),
                    ))),
            buttonInfiniteWidth(
                "Ajouter un cours",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCoursForm(),
                    ))),
            // buttonInfiniteWidth(
            //     "Liste des Quiz",
            //     () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ListQuiz(),
            //         ))),
            buttonInfiniteWidth(
                "Ajouter un quiz",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateQuiz(),
                    ))),
            // buttonInfiniteWidth("Ajouter des questions à un quiz existant"),
          ],
        ),
      ),
    );
  }
}

Widget button(String text, [Function()? fonction]) => OutlinedButton(
      onPressed: fonction,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.purple, width: 3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );

Widget buttonInfiniteWidth(String text, [Function()? fonction]) => Container(
      height: 45,
      margin: const EdgeInsetsDirectional.only(
          start: 20, top: 10, bottom: 10, end: 20),
      width: double.infinity,
      child: button(text, fonction),
    );
