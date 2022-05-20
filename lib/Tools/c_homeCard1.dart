// ignore_for_file: file_names, non_constant_identifier_names
import 'package:flutter/material.dart';
import '../utils/dimension.dart';
import '../utils/uicolors.dart';

Container c_homeCard1(String text, String secondaryText, String image) {
  return Container(
    width: size150,
    height: size160,
    decoration: BoxDecoration(color: white, boxShadow: [
      BoxShadow(
          color: black.withOpacity(0.2),
          spreadRadius: 1.0,
          blurRadius: 4,
          offset: const Offset(0.0, 3.0))
    ]),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          width: size70,
          height: size70,
        ),
        SizedBox(
          height: size5,
        ),
        Text(
          text,
          style: TextStyle(
              color: black,
              fontSize: size16,
              fontFamily: "Saira",
              fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: size5,
        ),
        Text(
          secondaryText,
          style: TextStyle(
              color: grey11,
              fontSize: size14,
              fontFamily: "Saira",
              fontWeight: FontWeight.w300),
        ),
      ],
    ),
  );
}
