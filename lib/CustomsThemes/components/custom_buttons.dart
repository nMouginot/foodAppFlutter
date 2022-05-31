import 'package:flutter/material.dart';

const buttonMinimumSize = Size(100, 40);

// ignore: non_constant_identifier_names
final ButtonStyle TEST_DEBUG_elevatedButton = ElevatedButton.styleFrom(
  onPrimary: Colors.yellow,
  primary: Colors.yellow,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(2),
    ),
  ),
);

final ButtonStyle elevatedButtonBlack = ElevatedButton.styleFrom(
  onPrimary: Colors.grey[300],
  primary: Colors.black87,
  minimumSize: buttonMinimumSize,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

final ButtonStyle darkThemeElevatedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: buttonMinimumSize,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

final ButtonStyle lightThemeElevatedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue[300],
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
