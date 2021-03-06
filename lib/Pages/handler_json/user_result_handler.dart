import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/Pages/handler_json/tool_handler.dart';

/* Ressources : 
https://pub.dev/packages/path_provider/example
https://betterprogramming.pub/how-to-handle-data-locally-in-flutter-79506abc07c9 */

// Enregistre les mainModules et les modules
class UserResultHandler {
  static final UserResultHandler _fileHandler = UserResultHandler._internal();
  factory UserResultHandler() {
    return _fileHandler;
  }
  UserResultHandler._internal();

// #region utils
  /// Récupère les données présentes dans le fichier local [URInvQuizFile]
  static Future<List<Quiz>> getFileContent() async {
    var file = await ToolHandler.getFile(JsonFile.userResultQuizs);
    var jsonData = await file.readAsString();
    if (jsonData == "") {
      return List<Quiz>.empty(growable: true);
    }

    var fileContent =
        (jsonDecode(jsonData) as List).map((i) => Quiz.fromJson(i)).toList();

    if (fileContent.isEmpty) {
      return List<Quiz>.empty(growable: true);
    }
    return fileContent;
  }

  /// Permet de générer un nouvel id qui n'est pas présent dans le fichier de stockage local des quizs.
  static Future<int> _getUniqueId() async {
    // TODO utiliser les ID serveurs, c'est mieux qu'un truc en liste local pour généré des id proprements.
    var allQuiz = await getFileContent();
    if (allQuiz.isNotEmpty) {
      int uniqueId = allQuiz.last.id + 1;
      while (allQuiz.where((element) => element.id == uniqueId).isNotEmpty) {
        uniqueId++;
      }
      return uniqueId;
    } else {
      return 1;
    }
  }
// #endregion

  // Permet d'ajouter un quiz sans lui définir d'id.
  static Future<int> addNotedQuizWithGeneratedId({required Quiz quiz}) async {
    return await _addNotedQuiz(Quiz.fromQuizChangeId(
        id: await _getUniqueId(), answerDate: DateTime.now(), quiz: quiz));
  }

  static Future<int> _addNotedQuiz(Quiz quiz) async {
    var file = await ToolHandler.getFile(JsonFile.userResultQuizs);
    var allNotedQuiz = await getFileContent();

    // On test si un mainModule n'a pas déjà cet id dans le stockage
    if (allNotedQuiz.where((element) => element.id == quiz.id).isNotEmpty) {
      debugPrint(
          "(userResultHandler) L'id du quiz à ajouter au stockage local est déjà utilisé. Ajout refusé.");
      return -1;
    }

    // On ajoute le nouveau mainModule
    allNotedQuiz.add(quiz);

    // On écrase le fichier avec les anciennes ET la nouvelle valeur.
    var writeStream = file.openWrite(mode: FileMode.write);
    writeStream.write(jsonEncode(allNotedQuiz));
    await writeStream.close();

    return quiz.id;
  }

  /// Retourne le résultat du quiz si il y en a un ou null si le fichier du quiz n'est pas existant ou que l'[id] n'est pas existant.
  static Future<Quiz?> getQuizResultById(int id) async {
    var allNotedQuiz = await getFileContent();

    if (allNotedQuiz.where((element) => element.id == id).isEmpty) {
      debugPrint("Il n'y a pas de quiz avec cet id.");
      return null;
    } else {
      return allNotedQuiz.where((element) => element.id == id).first;
    }
  }

  /// Retourne les résultats d'un model de quiz si il y en a un ou null si le fichier du quiz n'est pas existant ou que le [quizId] n'est pas existant.
  static Future<List<Quiz>?> getQuizResultByQuizId(int quizId) async {
    var allNotedQuiz = await getFileContent();

    if (allNotedQuiz.where((element) => element.quizId == quizId).isEmpty) {
      debugPrint("Il n'y a pas de quiz avec cet id.");
      return null;
    } else {
      return allNotedQuiz.where((element) => element.quizId == quizId).toList();
    }
  }

  /// Récupère tout les quizs actuellement non noté stocké en local. Si il n'y en a pas, retourne [null]
  /// La liste est déjà trier par date de réponse, de la plus vieille à la plus récente. (Du plus urgent à corriger au moins urgent.)
  static Future<List<Quiz>?> getQuizsToGrade() async {
    var allQuizToGrade = await getFileContent();

    if (allQuizToGrade
        .where((element) => element.moduleGraded == false)
        .isEmpty) {
      debugPrint("Il n'y a pas de quiz à noté.");
      return null;
    } else {
      allQuizToGrade.where((element) => element.moduleGraded == false).toList();
      allQuizToGrade.sort(((a, b) => a.answerDate.compareTo(b.answerDate)));
      return allQuizToGrade;
    }
  }

//   // Récupère les données présentes dans le fichier local de gestion des mainModules
//   static Future<List<MainModule>> getInvValue() async {
//     var mInvFile = await _getURInvQuizFile();
//     var mInvFileJsonData = await mInvFile.readAsString();
//     if (mInvFileJsonData == "") {
//       return List<MainModule>.empty(growable: true);
//     }

//     var urInvQuizFileValue = (jsonDecode(mInvFileJsonData) as List)
//         .map((i) => MainModule.fromJson(i))
//         .toList();

//     if (urInvQuizFileValue.isEmpty) {
//       return List<MainModule>.empty(growable: true);
//     }
//     return urInvQuizFileValue;
//   }
}
