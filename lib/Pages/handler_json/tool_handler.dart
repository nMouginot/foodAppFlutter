import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Tools/prettyJsonDisplay.dart';
import 'package:path_provider/path_provider.dart';

enum JsonFile {
  userResultQuizs,
  teacherQuizToGrade,
  modules,
}

class ToolHandler {
  /// Affiche dans la console la liste de tout les fichiers présent dans l'emplacement de sauvegarde dédié de l'app.
  static void getAllFileDebug() async {
    debugPrint(
        "\n-----------------------------------------------------------\nGET ALL FILES DEBUG :");
    final directory = await getApplicationDocumentsDirectory();
    int count = 0;

    (await Directory(directory.path).list().toList())
        .whereType<File>()
        .forEach((element) {
      debugPrint("Files[$count] : ${element.path}");
      count++;
    });
  }

  /// Affiche le contenu d'un fichier, selectionner par index. (On peut voir les index en affichant la liste des fichiers existant avec la méthode [getAllFileDebug])
  static void getFileContentDebug(int index) async {
    debugPrint(
        "\n-----------------------------------------------------------\nGET FILE [$index] :");
    final directory = await getApplicationDocumentsDirectory();
    var stringToDisplay =
        await (await Directory(directory.path).list().toList())
            .whereType<File>()
            .elementAt(index)
            .readAsString();

    PrettyJsonDisplay.prettyPrintJson(stringToDisplay);
  }

  /// Récupère le fichier .json [jsonFile] enregistré en local.
  static Future<File> getFile(JsonFile jsonFile) async {
    switch (jsonFile) {
      case JsonFile.modules:
        return _getJsonStorageFile("MInv.json");

      case JsonFile.userResultQuizs:
        return _getJsonStorageFile("URInvQuiz.json");

      case JsonFile.teacherQuizToGrade:
        return _getJsonStorageFile("URInvQuizToGrade.json");
    }
  }

// #region méthodes privés

  /// Récupère le fichier dont le nom est passé en parametre [jsonFileName].
  static Future<File> _getJsonStorageFile(String jsonFileName) async {
    final directory = await getApplicationDocumentsDirectory();
    var invFile = File("${directory.path}/$jsonFileName");
    if (await invFile.exists()) {
      return invFile;
    } else {
      debugPrint("Fichier $jsonFileName non existant.");
      return await File("${directory.path}/$jsonFileName").create();
    }
  }

// #endregion
}
