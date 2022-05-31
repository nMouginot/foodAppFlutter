import 'package:flutter/material.dart';
import 'package:flutter_food_app/Components/c_divider1.dart';
import 'package:flutter_food_app/Model/QuizFilters.dart';

class ListQuizFilters extends StatefulWidget {
  const ListQuizFilters({Key? key, required this.quizFilters})
      : super(key: key);

  final QuizFilters quizFilters;

  @override
  ListQuizFiltersState createState() => ListQuizFiltersState();
}

class ListQuizFiltersState extends State<ListQuizFilters> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.quizFilters);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(centerTitle: true, title: const Text("Filtres")),
          body: Column(
            children: [
              switchButtonRow(
                  "Quiz d'entrainement",
                  widget.quizFilters.isTraining,
                  () => {
                        widget.quizFilters.isTraining =
                            !widget.quizFilters.isTraining
                      }),
              switchButtonRow(
                  "Quiz Evalué",
                  widget.quizFilters.isGraded,
                  () => {
                        widget.quizFilters.isGraded =
                            !widget.quizFilters.isGraded
                      }),
              c_divider1(),
            ],
          )),
    );
  }

  Container switchButtonRow(
      String lineText, bool switchValue, Function() buttonAction) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(lineText),
          Switch(
            value: switchValue,
            onChanged: (value) => {
              setState(() {
                buttonAction();
              })
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
