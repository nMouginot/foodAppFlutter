import 'package:flutter/material.dart';
import 'package:flutter_food_app/Tools/c_homeCard1.dart';
import '../../utils/dimension.dart';
import '../../utils/strings.dart';
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
        title: const Text("Home"),
      ),
      body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => {print("Quiz d'entrainement tapped")},
                  child: c_homeCard1("Quiz d'entrainement", "Sub text",
                      "assets/images/placeholder.png"),
                ),
                GestureDetector(
                  onTap: () => {print("Quiz noté")},
                  child: c_homeCard1("Quiz noté", "Sub text 2",
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
                c_homeCard1(
                    "Notes", "Sub text", "assets/images/placeholder.png"),
                c_homeCard1("Statistiques", "Sub text 2",
                    "assets/images/placeholder.png"),
              ],
            ),
            SizedBox(
              height: size30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                c_homeCard1("Support de cours", "Sub text",
                    "assets/images/placeholder.png"),
                c_homeCard1(
                    "Modules", "Sub text 2", "assets/images/placeholder.png"),
              ],
            ),
          ]),
    );
  }
}
