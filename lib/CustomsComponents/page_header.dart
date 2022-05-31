// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

Widget PageHeader({required String title, required Widget child}) {
  return Scaffold(
    appBar: AppBar(
      elevation: 5.0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: white,
      title: Text(
        title,
        style: TextStyle(
            color: black,
            fontSize: size18,
            fontFamily: "Saira",
            fontWeight: FontWeight.w400),
      ),
    ),
    body: Stack(
      children: [
        // Fond de la page
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/images/screen_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    ),
  );
}
