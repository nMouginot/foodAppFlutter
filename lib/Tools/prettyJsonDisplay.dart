// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class PrettyJsonDisplay {
  static JsonDecoder decoder = const JsonDecoder();
  static JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  static void prettyPrintJson(String input) {
    var object = decoder.convert(input);
    var prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((element) => debugPrint(element));
  }
}
