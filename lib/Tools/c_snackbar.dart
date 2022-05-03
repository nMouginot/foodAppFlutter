// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

SnackBar c_snackbar(String text) {
  return SnackBar(
      content: Text(text), duration: const Duration(milliseconds: 300));
}
