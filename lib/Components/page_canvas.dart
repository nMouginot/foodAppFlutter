import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

class PageCanvas extends StatefulWidget {
  const PageCanvas({Key? key, required this.title, required this.pageWidget})
      : super(key: key);

  final Widget pageWidget;
  final String title;

  @override
  TtestState createState() => TtestState();
}

class TtestState extends State<PageCanvas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          widget.title,
          style: TextStyle(
              color: black,
              fontSize: size18,
              fontFamily: "Saira",
              fontWeight: FontWeight.w400),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.maxFinite,
            child: Image.asset(
              "assets/images/screen_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          widget.pageWidget
        ],
      ),
    );
  }
}
