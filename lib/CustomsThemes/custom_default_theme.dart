import 'package:flutter/material.dart';

var defautTheme = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.orange),
  // fontFamily: 'SourceSansPro',
  textTheme: TextTheme(
    headline3: const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 45.0,
      // fontWeight: FontWeight.w400,
      color: Colors.purple,
    ),
    button: const TextStyle(
      // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
      fontFamily: 'OpenSans',
    ),
    caption: TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.deepPurple[300],
    ),
    headline1: const TextStyle(fontFamily: 'Quicksand'),
    headline2: const TextStyle(fontFamily: 'Quicksand'),
    headline4: const TextStyle(fontFamily: 'Quicksand'),
    headline5: const TextStyle(fontFamily: 'NotoSans'),
    headline6: const TextStyle(fontFamily: 'NotoSans'),
    subtitle1: const TextStyle(fontFamily: 'NotoSans'),
    bodyText1: const TextStyle(fontFamily: 'NotoSans'),
    bodyText2: const TextStyle(fontFamily: 'NotoSans'),
    subtitle2: const TextStyle(fontFamily: 'NotoSans'),
    overline: const TextStyle(fontFamily: 'NotoSans'),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
      .copyWith(secondary: Colors.deepPurple),
);
