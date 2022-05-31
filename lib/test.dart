import 'package:flutter/material.dart';
import 'package:flutter_food_app/Components/page_canvas.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return PageCanvas(title: "Page de test", pageWidget: Container());
  }
}
