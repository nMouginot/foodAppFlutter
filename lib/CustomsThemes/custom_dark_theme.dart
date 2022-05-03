import 'package:flutter/material.dart';
import 'custom_buttons.dart';
import 'custom_text.dart';

ThemeData customDarkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  colorScheme: _customColorDarkScheme,
  elevatedButtonTheme:
      ElevatedButtonThemeData(style: darkThemeElevatedButtonStyle),
  textTheme: TextTheme(
    bodyText1: darkThemeBodyText1TextStyle, // Texte de base
    bodyText2: darkThemeBodyText2TextStyle, // Texte plus légerplus léger
    headline4: darkThemeHeadline4TextStyle,
    headline5: darkThemeHeadline5TextStyle,
    headline6: darkThemeHeadline6TextStyle,
  ),
);

const ColorScheme _customColorDarkScheme = ColorScheme(
  primary: Color(0xff2196f3),
  primaryContainer: Color(0xff000000),
  secondary: Color(0xffeeeeee),
  secondaryContainer: Color(0xff505050),
  surface: Color(0xff424242),
  background: Color(0xff000000),
  error: Color(0xffd32f2f),
  onPrimary: Color(0xffffffff),
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffffffff),
  onBackground: Color(0xffffffff),
  onError: Color(0xff000000),
  brightness: Brightness.dark,
);
