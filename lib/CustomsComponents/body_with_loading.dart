// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

Widget BodyWithLoading({required Widget child, required bool isLoading}) {
  return (isLoading)
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : child;
}
