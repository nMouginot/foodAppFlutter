// ignore_for_file: file_names
import 'dart:convert';

//Model représentant un support de cours PDF sauvegardé en local.
class CoursPdf {
  final int id; // Identifiant unique permettant de repérer un cours.
  String matiere; // Matiere du support de cours
  String level; // Niveau du support de cours
  String name; // Nom du support de cours
  String path; // Nom du support de cours
  int accessibility; // Niveau d'accécibilité du cours, plus le chiffre est haut, moins le cours est accessible.
  //(Permet d'avoir un affinage plus précis que "freemium ou non" pour potentiellement avoir plusieurs offre
  //avec différent cours accessible.)
  bool freemiumAccess; // Accès gratuit au support de cours.
  bool downloaded; // Si le support de cours est téléchargé ou pas
  // Le chemin du support de cours est le stockage de l'application + le nom du cours.

  CoursPdf(
      {required this.id,
      required this.matiere,
      required this.level,
      required this.name,
      required this.path,
      required this.accessibility,
      required this.freemiumAccess,
      required this.downloaded});

  CoursPdf.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        matiere = json['matiere'],
        level = json['level'],
        name = json['name'],
        path = json['path'],
        accessibility = json['accessibility'],
        freemiumAccess = json['freemiumAccess'],
        downloaded = json['downloaded'];

  // Permet de transformer un objet 'CoursPdf' en string JSON.
  String toJsonEncoded() => jsonEncode({
        'id': id,
        'matiere': matiere,
        'level': level,
        'name': name,
        'path': path,
        'accessibility': accessibility,
        'freemiumAccess': freemiumAccess,
        'downloaded': downloaded
      });

  // Permet de décodé un objet avec une string JSON de celui ci.
  static CoursPdf fromJsonDecoded(String jsonString) {
    Map<String, dynamic> coursPdfMap = jsonDecode(jsonString);
    var result = CoursPdf.fromJson(coursPdfMap);
    return result;
  }

  // Permet de décodé une liste d'objet avec une string JSON de celui ci.
  static List<CoursPdf> fromJsonDecodedList(String jsonString) {
    Iterable l = json.decode(jsonString);
    List<CoursPdf> result =
        List<CoursPdf>.from(l.map((model) => CoursPdf.fromJson(model)));
    return result;
  }

  // retourne un String qui formaté en JSON de la liste passé en parametre.
  static String toJsonEncodedList(List<CoursPdf> listCours) {
    if (listCours.length > 1) {
      String jsonResult = "[";

      for (var element in listCours) {
        jsonResult += element.toJsonEncoded();

        jsonResult += ",";
      }

// On supprime le dernier caractère ',' qui est en trop, puis on ferme la liste JSON.
      jsonResult = jsonResult.substring(0, jsonResult.length - 1);
      jsonResult += "]";

      return jsonResult;
    } else {
      return "[${listCours.first.toJsonEncoded()}]";
    }
  }
}
