import 'package:flutter/material.dart';
import 'package:flutter_food_app/Components/c_divider1.dart';
import 'package:flutter_food_app/Components/c_header1.dart';
import 'package:flutter_food_app/Components/c_snackbar.dart';
import 'package:flutter_food_app/CustomsThemes/custom_dark_theme.dart';
import 'package:flutter_food_app/CustomsThemes/custom_light_theme.dart';
import 'package:flutter_food_app/Pages/Page%20Options/language_list.dart';

import '../../main.dart';

class MainOptions extends StatefulWidget {
  const MainOptions({Key? key}) : super(key: key);

  @override
  _MainOptionsState createState() => _MainOptionsState();
}

class _MainOptionsState extends State<MainOptions> {
  bool isSwitchedDarkColorTheme = false;

  @override
  Widget build(BuildContext context) {
    // Défini si le theme est en dark ou non.
    isSwitchedDarkColorTheme =
        (Theme.of(context).brightness == Brightness.dark) ? true : false;
    // Affichage
    return Scaffold(
      appBar: AppBar(title: const Text("Options")),
      body: Column(
        children: [
          c_header1(Icons.bookmarks_outlined, "Common", context: context),
          c_divider1(),
          settingsTextRow(
              "Language",
              "English",
              () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LanguageList()))
                  }),
          settingsTextRow(
              "Option",
              "valeur",
              () => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(c_snackbar("Clic option"))
                  }),
          c_header1(Icons.add_to_home_screen_rounded, "Themes",
              context: context),
          c_divider1(),
          settingsSwitchButtonRow("Dark theme", null),
          settingsTextRow(
              "Option 1",
              "valeur 1",
              () => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(c_snackbar("Clic option 1"))
                  }),
          settingsTextRow(
            "Option 2",
            "valeur 2",
            () => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(c_snackbar("Clic option 2"))
            },
          )
        ],
      ),
    );
  }

  Text settingsRowIconAndName(String text) {
    return Text(text, style: Theme.of(context).textTheme.bodyText1);
  }

  Container settingsTextRow(
      String lineText, String buttonText, Function()? buttonAction) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          settingsRowIconAndName(lineText),
          buttonArrow(buttonText, buttonAction)
        ],
      ),
    );
  }

  Container settingsSwitchButtonRow(String lineText, Function()? buttonAction) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          settingsRowIconAndName(lineText),
          Switch(
            value: isSwitchedDarkColorTheme,
            onChanged: (value) {
              setState(
                () {
                  isSwitchedDarkColorTheme = value;

                  if (isSwitchedDarkColorTheme == true) {
                    MyApp.of(context)!.changeTheme(customDarkTheme);
                  } else if (isSwitchedDarkColorTheme == false) {
                    MyApp.of(context)!.changeTheme(customLightTheme);
                  }
                },
              );
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  GestureDetector buttonArrow(String text, Function()? action) {
    return GestureDetector(
      onTap: action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.secondary)
        ],
      ),
    );
  }
}
