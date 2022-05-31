// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

//Model représentant un support de cours PDF sauvegardé sur le serveur.
class ServerCoursModel {
  final int id; // Identifiant unique permettant de repérer un cours.
  final String name; // Nom du support de cours
  final bool freemiumAccess; // Accès gratuit au support de cours.
  final String matiere; // Matiere du support de cours
  final String level; // Niveau du support de cours
  final int
      accessibility; // Niveau d'accécibilité du cours, plus le chiffre est haut, moins le cours est accessible.
  //(Permet d'avoir un affinage plus précis que "freemium ou non" pour potentiellement avoir plusieurs offre
  //avec différent cours accessible.)

  ServerCoursModel(this.id, this.name, this.freemiumAccess, this.matiere,
      this.level, this.accessibility);

  ServerCoursModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        freemiumAccess = json['freemiumAccess'],
        matiere = json['matiere'],
        level = json['level'],
        accessibility = json['accessibility'];

  // Permet de décodé un objet avec une string JSON de celui ci.
  static ServerCoursModel fromJsonDecoded(String jsonString) {
    Map<String, dynamic> coursPdfMap = jsonDecode(jsonString);
    var result = ServerCoursModel.fromJson(coursPdfMap);
    return result;
  }

  // Permet de décodé une liste d'objets avec une string JSON de ceux-ci.
  static List<ServerCoursModel> fromListJsonDecoded(String jsonString) {
    Iterable l = json.decode(jsonString);
    List<ServerCoursModel> result = List<ServerCoursModel>.from(
        l.map((model) => ServerCoursModel.fromJson(model)));
    return result;
  }
}
