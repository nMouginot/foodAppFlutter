import 'package:flutter/material.dart';
import 'package:flutter_food_app/Pages/Page%20Home/main_home.dart';
import 'Pages/Page Home/debug_home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeData _themeData = ThemeData();
  void changeTheme(ThemeData themeData) {
    setState(() {
      _themeData = themeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      themeMode: (_themeData.brightness == Brightness.light)
          ? ThemeMode.light
          : ThemeMode.dark,
      theme: _themeData,
      home: const Home(),
    );
  }
}
