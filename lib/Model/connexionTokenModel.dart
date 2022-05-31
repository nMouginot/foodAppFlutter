// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class ConnexionTokenModel {
  final String access_token;
  final String refresh_token;
  final String token_type;
  final int expires_in;

  ConnexionTokenModel(
      this.access_token, this.refresh_token, this.token_type, this.expires_in);

  ConnexionTokenModel.fromJson(Map<String, dynamic> json)
      : access_token = json['access_token'],
        refresh_token = json['refresh_token'],
        token_type = json['token_type'],
        expires_in = json['expires_in'];

  // Permet de décodé un objet avec une string JSON de celui ci.
  static ConnexionTokenModel fromJsonDecoded(String jsonString) {
    Map<String, dynamic> coursPdfMap = jsonDecode(jsonString);
    var result = ConnexionTokenModel.fromJson(coursPdfMap);
    return result;
  }
}
