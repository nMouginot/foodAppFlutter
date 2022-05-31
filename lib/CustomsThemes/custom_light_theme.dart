import 'package:flutter/material.dart';

import 'components/custom_buttons.dart';
import 'components/custom_text.dart';

ThemeData customLightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  colorScheme: _customColorLightScheme,
  elevatedButtonTheme:
      ElevatedButtonThemeData(style: lightThemeElevatedButtonStyle),
  textTheme: TextTheme(
    bodyText1: lightThemeBodyText1TextStyle, // Texte de base
    bodyText2: lightThemeBodyText2TextStyle, // Texte plus léger
    headline4: lightThemeHeadline4TextStyle,
    headline5: lightThemeHeadline4TextStyle,
    headline6: lightThemeHeadline6TextStyle,
  ),
);

const ColorScheme _customColorLightScheme = ColorScheme(
  primary: Color(0xff2196f3),
  primaryContainer: Color(0xff000000),
  secondary: Color(0xffeeeeee),
  secondaryContainer: Color(0xff505050),
  surface: Color(0xff424242),
  background: Color(0xff303030),
  error: Color(0xffd32f2f),
  //
  onPrimary: Color(0xffffffff),
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffffffff),
  onBackground: Color(0xffffffff),
  onError: Color(0xff000000),
  brightness: Brightness.light,
);
