import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/Model/MainModule.dart';
import 'package:flutter_food_app/Model/ModuleId.dart';
import 'package:flutter_food_app/Pages/handler_json/tool_handler.dart';

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

// #region utils
  /// Récupère les données présentes dans le fichier local de gestion des modules
  static Future<List<MainModule>> getMInvValue() async {
    var qInvFile = await ToolHandler.getFile(JsonFile.modules);
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

  /// Permet de récupérer un [id] qui n'est pas présent dans le fichier de stockage
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

// #region add MainModule

  /// Permet d'ajouter un quiz sans lui définir d'[id].
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

  /// Ajoute un module dans le stockage
  static Future<int> _addMainModuleToMInv(MainModule mainModule) async {
    // On récupère les mainModules déjà présents

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
    _saveToJsonFile(allMainModule);

    return mainModule.id;
  }

// #endregion

  /// Retourne un module ciblé par son [id]
  static Future<MainModule?> getMainModuleById(int id) async {
    var allMainModule = await getMInvValue();

    if (allMainModule.where((element) => element.id == id).isEmpty) {
      debugPrint("Il n'y a pas de quiz avec cet id.");
      return null;
    } else {
      return allMainModule.where((element) => element.id == id).first;
    }
  }

  /// Essai de modifier la variable [MainModule.completionOfTheMainModule] d'un [MainModule] déjà sauvegardé.
  /// Si il n'est pas existant retourne false, si tout c'est bien passé, retourne true.
  static Future<bool> changeMainModuleCompletionById(
      int id, int moduleCompletion) async {
    if (getMainModuleById(id) != null) {
      var allMainModule = await getMInvValue();
      MainModule mainModule =
          allMainModule.where((element) => element.id == id).first;
      mainModule.completionOfTheMainModule = moduleCompletion;
      _saveToJsonFile(allMainModule);
      return true;
    } else {
      return false;
    }
  }

  static void _saveToJsonFile(List<MainModule> allMainModule) async {
    var mInvFile = await ToolHandler.getFile(JsonFile.modules);
    // On écrase le fichier avec les anciennes ET la nouvelle valeur.
    String allMainModuleJson = jsonEncode(allMainModule);

    var writeStream = mInvFile.openWrite(mode: FileMode.write);
    writeStream.write(allMainModuleJson);
    await writeStream.close();
  }
}
