// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ColorSchemeDisplay extends StatelessWidget {
  const ColorSchemeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          displayTextAndColor(
              "primary = ", Theme.of(context).colorScheme.primary, context),
          displayTextAndColor("primaryVariant = ",
              Theme.of(context).colorScheme.primaryContainer, context),
          displayTextAndColor(
              "secondary = ", Theme.of(context).colorScheme.secondary, context),
          displayTextAndColor("secondaryVariant = ",
              Theme.of(context).colorScheme.secondaryContainer, context),
          displayTextAndColor(
              "surface = ", Theme.of(context).colorScheme.surface, context),
          displayTextAndColor("background = ",
              Theme.of(context).colorScheme.background, context),
          displayTextAndColor(
              "error = ", Theme.of(context).colorScheme.error, context),
          displayTextAndColor(
              "onPrimary = ", Theme.of(context).colorScheme.onPrimary, context),
          displayTextAndColor("onSecondary = ",
              Theme.of(context).colorScheme.onSecondary, context),
          displayTextAndColor(
              "onSurface = ", Theme.of(context).colorScheme.onSurface, context),
          displayTextAndColor("onBackground = ",
              Theme.of(context).colorScheme.onBackground, context),
          displayTextAndColor(
              "onError = ", Theme.of(context).colorScheme.onError, context),
        ],
      ),
    );
  }
}

Row displayTextAndColor(String text, Color? color, BuildContext context) {
  return Row(
    children: [
      Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Container(
        height: 20,
        width: 20,
        color: color,
      ),
    ],
  );
}
