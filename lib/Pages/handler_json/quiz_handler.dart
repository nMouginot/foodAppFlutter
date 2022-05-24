import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Tools/prettyJsonDisplay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:http/http.dart' as http;

/* Ressources : 
https://pub.dev/packages/path_provider/example
https://betterprogramming.pub/how-to-handle-data-locally-in-flutter-79506abc07c9 */

// Enregistre les Quiz d'entrainement en local et créer un index en json.
class QuizHandler {
  static final QuizHandler _fileHandler = QuizHandler._internal();
  factory QuizHandler() {
    return _fileHandler;
  }
  QuizHandler._internal();

  // Fichier jsonfile contenant la liste de tout les Quiz enregisté en local sur le telephone de l'utilisateur.
  // Permet de séparer les fichiers des quiz dans d'autres documents json. Un document par quiz existant.
  // ignore: non_constant_identifier_names
  static String QInvFile = "QInv.json";
  static int lastAddedQuizId = 0;

  static void deleteFileByIndex(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = (await Directory(directory.path).list().toList())
        .whereType<File>()
        .elementAt(index);
    file.delete();

    debugPrint("File ${file.path} with index($index) have been deleted.");
  }

  // Récupère le fichier jsonFile enregistrer en local pour gérer les quizs
  static Future<File> _getQInvFile() async {
    final directory = await getApplicationDocumentsDirectory();
    var invFile = File("${directory.path}/$QInvFile");
    if (await invFile.exists()) {
      return invFile;
    } else {
      debugPrint("Fichier $QInvFile non existant.");
      return await File("${directory.path}/$QInvFile").create();
    }
  }

  // Récupère les données présentes dans le fichier local de gestion des quizs
  static Future<List<QuizWithoutQuestions>> getQInvValue() async {
    var qInvFile = await _getQInvFile();
    var qInvFileJsonData = await qInvFile.readAsString();
    if (qInvFileJsonData == "") {
      return List<QuizWithoutQuestions>.empty(growable: true);
    }

    var qInvFileValue = (jsonDecode(qInvFileJsonData) as List)
        .map((i) => QuizWithoutQuestions.fromJson(i))
        .toList();

    if (qInvFileValue.isEmpty) {
      return List<QuizWithoutQuestions>.empty(growable: true);
    }
    return qInvFileValue;
  }

  static Future<int> getUniqueId() async {
    var allQuiz = await getQInvValue();
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

  // Permet d'ajouter un quiz sans lui définir d'id.
  static Future<int> addQuizToQinvWithGeneratedId(
      {required String name,
      required int coefficient,
      required DateTime creationDate,
      required bool isTraining,
      required String matiere,
      required String niveau,
      required int timerQuiz}) async {
    return await _addQuizToQInv(QuizWithoutQuestions(
        id: await getUniqueId(),
        name: name,
        niveau: niveau,
        matiere: matiere,
        coefficient: coefficient,
        isTraining: isTraining,
        timerQuiz: timerQuiz,
        creationDate: creationDate));
  }

  // Ajoute un nouveau quiz dans QInv.json et retourne son id.
  static Future<int> _addQuizToQInv(QuizWithoutQuestions quiz) async {
    // On récupère les quiz déjà présents
    var qInvFile = await _getQInvFile();
    var allQuiz = await getQInvValue();

    // On test si un quiz n'a pas déjà cet id dans le stockage
    if (allQuiz.where((element) => element.id == quiz.id).isNotEmpty) {
      debugPrint(
          "(QuizHandler) L'id du quiz à ajouter au stockage local est déjà utilisé. Ajout refusé.");
      return -1;
    }

    // On ajoute le nouveau quiz
    allQuiz.add(quiz);

    // On écrase le fichier avec les anciennes ET la nouvelle valeur.
    String allQuizJson = jsonEncode(allQuiz);

    var writeStream = qInvFile.openWrite(mode: FileMode.write);
    writeStream.write(allQuizJson);
    await writeStream.close();

    lastAddedQuizId = quiz.id;
    return lastAddedQuizId;
  }

  // Supprime un quiz
  static Future<bool> deleteQuizInQInv(QuizWithoutQuestions quiz) async {
    // On récupère les quiz déjà présents
    var qInvFile = await _getQInvFile();
    var allQuiz = await getQInvValue();

    // On test si il y a un quiz avec cet id dans le stockage
    if (allQuiz.where((element) => element.id == quiz.id).isEmpty) {
      debugPrint("(QuizHandler) Il n'y a pas de quiz existant avec cet id.");
      return false;
    }

    if (allQuiz.where((element) => element.id == quiz.id).isNotEmpty) {
      allQuiz.remove(allQuiz.where((element) => element.id == quiz.id).first);
      // On écrase le fichier avec les anciennes ET sans la valeur supprimé.
      String allQuizJson = jsonEncode(allQuiz);

      var writeStream = qInvFile.openWrite(mode: FileMode.write);
      writeStream.write(allQuizJson);
      await writeStream.close();

      lastAddedQuizId = quiz.id;
      return true;
    } else {
      debugPrint(
          "(QuizHandler) Il n'y a pas de quiz existant possible à supprimer.");
      return false;
    }
  }

  // Supprime le fichier QInvFile. (Et donc, tout les qcm sauvegardés en local, utile si il y a un changement dans la classe "QuizWithoutQuestions")
  static Future<bool> deleteQInvFile() async {
    var qInvFile = await _getQInvFile();
    qInvFile.delete();
    return true;
  }

// Retourne le quiz si il y en a un ou null si le fichier du quiz n'est pas existant ou que l'id n'est pas existant dans QInv.
  static Future<Quiz?> getQuizById(int id) async {
    var allQuiz = await getQInvValue();

    if (allQuiz.where((element) => element.id == id).isEmpty) {
      debugPrint("Il n'y a pas de quiz avec cet id.");
      return null;
    }

    final quiz = allQuiz.where((element) => element.id == id).first;
    final directory = await getApplicationDocumentsDirectory();
    final quizFile = File("${directory.path}/${quiz.storageFileName}");

    if (await quizFile.exists()) {
      return Quiz.fromJson(jsonDecode(await quizFile.readAsString()));
    } else {
      debugPrint(
          "Il n'y a pas de fichier correspondant à ce quiz. => QuizId:${quiz.id} QuizStorage:${quiz.storageFileName}");
      return null;
    }
  }

  static Future<QuizWithoutQuestions?> getQuizWithoutQuestionsById(
      int id) async {
    var allQuiz = await getQInvValue();

    if (allQuiz.where((element) => element.id == id).isEmpty) {
      debugPrint(
          "(quizHandler/getQuizWithoutQuestionsById) Il n'y a pas de quiz avec cet id.");
      return null;
    }
    return allQuiz.where((element) => element.id == id).first;
  }

  // Ajoute le quiz a son fichier json personalisé et si son id n'est pas existant dans Qinv, l'ajoute dedans.
  static Future addQuiz(Quiz quiz) async {
    var allQuiz = await getQInvValue();

    if (allQuiz.where((element) => element.id == quiz.id).isEmpty) {
      debugPrint(
          "(quizHandler/addQuiz) Il n'y a pas de quiz avec cet id dans QInv.");

      await _addQuizToQInv(QuizWithoutQuestions.FromQuiz(quiz: quiz));
    }

/* Attention, il est nécéssaire d'utiliser le model stocké dans "quizInAllQuiz" et non 
   le parametre "quiz" car le chemin d'accès du fichier est basé sur la date du jour, et cela modifie le parametre envoyé.
   (Cas de figure uniquement présent si le fichier est non existant lors du chargement du quiz et qu'il doit être ajouter.)
*/
    final quizRefInAllQuiz =
        allQuiz.where((element) => element.id == quiz.id).first;
    final directory = await getApplicationDocumentsDirectory();
    var quizFile =
        File("${directory.path}/${quizRefInAllQuiz.storageFileName}");

    // Vérification si le fichier de stockage de ce quiz existe, si non, le créer.
    if (await quizFile.exists()) {
    } else {
      debugPrint(
          "(addQuiz) Il n'y a pas de fichier correspondant à ce quiz. => QuizId:${quiz.id} QuizStorage:${quizRefInAllQuiz.storageFileName}");
      quizFile =
          await File("${directory.path}/${quizRefInAllQuiz.storageFileName}")
              .create();
    }

    // On écrase le fichier du quiz avec les nouvelles données.
    String quizJson = jsonEncode(quiz);

    var writeStream = quizFile.openWrite(mode: FileMode.write);
    writeStream.write(quizJson);
    await writeStream.close();
  }
}
