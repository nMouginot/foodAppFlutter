// ignore_for_file: file_names
import 'dart:convert';

class PrettyJsonDisplay {
  static JsonDecoder decoder = JsonDecoder();
  static JsonEncoder encoder = JsonEncoder.withIndent('  ');

  static void prettyPrintJson(String input) {
    var object = decoder.convert(input);
    var prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((element) => print(element));
  }
}
