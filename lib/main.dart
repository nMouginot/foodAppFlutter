import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Pages/Login/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'CustomsThemes/custom_default_theme.dart';
import 'utils/MyHttpOverrides.dart';

void main() {
  // ! Permet d'ignorer le certificat SSL en cas de debug. Permet d'utiliser le serveur local pour le mobile.
  if (!kReleaseMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
// A modifier avec un stockage d'un json pour les parametres.
  bool appPrefInit = false;

  ThemeData _themeData = defautTheme;

  void changeTheme(ThemeData themeData) {
    setState(() {
      _themeData = themeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      home: (false)
          ? IntroductionScreen()
          : const LoginScreen(), // TODO Tester dans le json parametre general si il doit voir la page d'introduction ou de login
    );
  }
}
