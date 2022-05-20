import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/Model/MainModule.dart';
import 'package:flutter_food_app/Model/ModuleId.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/* Ressources : 
https://pub.dev/packages/path_provider/example
https://betterprogramming.pub/how-to-handle-data-locally-in-flutter-79506abc07c9 */

// Enregistre les mainModules et les modules
class ModuleHandler {
  static final ModuleHandler _fileHandler = ModuleHandler._internal();
  factory ModuleHandler() {
    return _fileHandler;
  }
  ModuleHandler._internal();

  // Fichier jsonfile contenant la liste de tout les Modules enregisté en local sur le telephone de l'utilisateur.
  // ignore: non_constant_identifier_names
  static String MInvFile = "MInv.json";

// #region utils

  // Récupère le fichier jsonFile enregistrer en local pour gérer les modules
  static Future<File> _getMInvFile() async {
    final directory = await getApplicationDocumentsDirectory();
    var invFile = File("${directory.path}/$MInvFile");
    if (await invFile.exists()) {
      return invFile;
    } else {
      debugPrint("Fichier $MInvFile non existant.");
      return await File("${directory.path}/$MInvFile").create();
    }
  }

  // Récupère les données présentes dans le fichier local de gestion des quizs
  static Future<List<MainModule>> getMInvValue() async {
    var qInvFile = await _getMInvFile();
    var qInvFileJsonData = await qInvFile.readAsString();
    if (qInvFileJsonData == "") {
      return List<MainModule>.empty(growable: true);
    }

    var qInvFileValue = (jsonDecode(qInvFileJsonData) as List)
        .map((i) => MainModule.fromJson(i))
        .toList();

    if (qInvFileValue.isEmpty) {
      return List<MainModule>.empty(growable: true);
    }
    return qInvFileValue;
  }

  static Future<int> getUniqueId() async {
    var allMainModule = await getMInvValue();
    if (allMainModule.isNotEmpty) {
      int uniqueId = allMainModule.last.id + 1;
      while (
          allMainModule.where((element) => element.id == uniqueId).isNotEmpty) {
        uniqueId++;
      }
      return uniqueId;
    } else {
      return 1;
    }
  }

// #endregion

  static void test() async {
    // On récupère les mainModules déjà présents
    var mInvFile = await _getMInvFile();
    var allMainModule = await getMInvValue();

    final mockModules = List<ModuleId>.empty();

    MainModule mainModule =
        MainModule(id: 0, name: "test", modulesId: mockModules);
    mainModule.modulesId.add(ModuleId(id: 1, type: ModuleType.quiz));
    mainModule.modulesId.add(ModuleId(id: 2, type: ModuleType.quiz));
    mainModule.modulesId.add(ModuleId(id: 3, type: ModuleType.cours));
    mainModule.modulesId.add(ModuleId(id: 4, type: ModuleType.indefini));

    List<MainModule> listMainModule = List<MainModule>.empty(growable: true);
    listMainModule.add(mainModule);
    listMainModule.add(MainModule(id: 1, name: "test", modulesId: mockModules));
    listMainModule.add(MainModule(id: 2, name: "test", modulesId: mockModules));
    listMainModule.add(MainModule(id: 3, name: "test", modulesId: mockModules));
    listMainModule.add(MainModule(id: 4, name: "test", modulesId: mockModules));

    // On écrase le fichier avec les anciennes ET la nouvelle valeur.
    String allMainModuleJson = jsonEncode(listMainModule);

    var writeStream = mInvFile.openWrite(mode: FileMode.write);
    writeStream.write(allMainModuleJson);
    await writeStream.close();
  }

// #region add MainModule

  // Permet d'ajouter un quiz sans lui définir d'id.
  static Future<int> addMainModuleToMInvWithGeneratedId(
      {required String name,
      required List<ModuleId> modules,
      String definition = ""}) async {
    return await _addMainModuleToMInv(MainModule(
        id: await getUniqueId(),
        name: name,
        modulesId: modules,
        definition: definition));
  }

  static Future<int> _addMainModuleToMInv(MainModule mainModule) async {
    // On récupère les mainModules déjà présents
    var mInvFile = await _getMInvFile();
    var allMainModule = await getMInvValue();

    // On test si un mainModule n'a pas déjà cet id dans le stockage
    if (allMainModule
        .where((element) => element.id == mainModule.id)
        .isNotEmpty) {
      debugPrint(
          "(ModuleHandler) L'id du mainModule à ajouter au stockage local est déjà utilisé. Ajout refusé.");
      return -1;
    }

    // On ajoute le nouveau mainModule
    allMainModule.add(mainModule);

    // On écrase le fichier avec les anciennes ET la nouvelle valeur.
    String allMainModuleJson = jsonEncode(allMainModule);

    var writeStream = mInvFile.openWrite(mode: FileMode.write);
    writeStream.write(allMainModuleJson);
    await writeStream.close();

    return mainModule.id;
  }

// #endregion

  // Retourne le quiz si il y en a un ou null si le fichier du quiz n'est pas existant ou que l'id n'est pas existant dans QInv.
  static Future<MainModule?> getMainModuleById(int id) async {
    var allMainModule = await getMInvValue();

    if (allMainModule.where((element) => element.id == id).isEmpty) {
      debugPrint("Il n'y a pas de quiz avec cet id.");
      return null;
    }
  }

  // Récupère les données présentes dans le fichier local de gestion des mainModules
  static Future<List<MainModule>> getInvValue() async {
    var mInvFile = await _getMInvFile();
    var mInvFileJsonData = await mInvFile.readAsString();
    if (mInvFileJsonData == "") {
      return List<MainModule>.empty(growable: true);
    }

    var qInvFileValue = (jsonDecode(mInvFileJsonData) as List)
        .map((i) => MainModule.fromJson(i))
        .toList();

    if (qInvFileValue.isEmpty) {
      return List<MainModule>.empty(growable: true);
    }
    return qInvFileValue;
  }
}
