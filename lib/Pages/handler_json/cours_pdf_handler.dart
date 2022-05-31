import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../Model/cours_pdf_model.dart';
import '../../utils/AppPreferences .dart';
import '../../utils/constants.dart';

/* Ressources : 
https://pub.dev/packages/path_provider/example
https://betterprogramming.pub/how-to-handle-data-locally-in-flutter-79506abc07c9 */

// Enregistre les PDF en local et créer un index en json contnant la liste des pdf enregistrés et leurs informations annexes. (matière, niveau)
class CoursPdfHandler {
  static final CoursPdfHandler _fileHandler = CoursPdfHandler._internal();
  factory CoursPdfHandler() {
    return _fileHandler;
  }
  CoursPdfHandler._internal();

  // Fichier json inventory contenant la liste de tout les PDF enregisté (ou non, voir la propiété "downloaded") en local sur le telephone de l'utilisateur.
  static String jsonFile = "CInv.json";

  static Future<File> _getInventory() async {
    final directory = await getApplicationDocumentsDirectory();
    var inventory = File("${directory.path}/$jsonFile");
    if (await inventory.exists()) {
      return inventory;
    } else {
      debugPrint("Fichier $jsonFile non existant.");
      return await File("${directory.path}/$jsonFile").create();
    }
  }

  // Récupère la liste des fichiers locaux (via le json inventaire)
  static Future<List<CoursPdf>> getJsonInventory() async {
    var inventory = await _getInventory();
    var inventoryText = await inventory.readAsString();
    if (inventoryText == "") {
      return List<CoursPdf>.empty(growable: true);
    }
    var jsonInventory = CoursPdf.fromJsonDecodedList(inventoryText);
    if (jsonInventory.isEmpty) {
      return List<CoursPdf>.empty(growable: true);
    }
    return jsonInventory;
  }

  // Ajoute un objet CoursPdf dans le fichier JSON inventory.
  static Future<bool> _addFileToJsonInventory(
      int id,
      String fileName,
      String matiere,
      String level,
      String path,
      int accessibility,
      bool downloaded,
      bool freemiumAccess) async {
    // Vérification si le nom est valide.
    fileName = _validateFileName(fileName);
    // On récupère les cours déjà présent
    var inventory = await _getInventory();
    var allCours = await getJsonInventory();
    // On ajoute le nouveau cours
    allCours.add(CoursPdf(
        id: id,
        name: fileName,
        level: level,
        matiere: matiere,
        path: path,
        accessibility: accessibility,
        downloaded: downloaded,
        freemiumAccess: freemiumAccess));

    // On écrase le fichier avec les anciennes et la nouvelle valeur.
    String dataAllCours = CoursPdf.toJsonEncodedList(allCours);
    print("AVANT :" + dataAllCours);

    var writeStream = inventory.openWrite(mode: FileMode.write);
    writeStream.write(dataAllCours);
    await writeStream.close();

    var a = await _getInventory();
    print("APRES :" + await a.readAsString());

    return true;
  }

  static Future<bool> addFileToJsonInventory(
      int id,
      String fileName,
      String matiere,
      String level,
      int accessibility,
      bool freemiumAccess) async {
    return await _addFileToJsonInventory(
        id, fileName, matiere, level, "", accessibility, false, freemiumAccess);
  }

  static void getJsonInventoryDebug() async {
    print("GET JSON INVENTORY DEBUG : ");
    var jsonInventory = await getJsonInventory();
    for (var i = 0; i < jsonInventory.length; i++) {
      print("Id:${jsonInventory[i].id}, name:${jsonInventory[i].name}");
    }
  }

  static void getBruteJsonDebug() async {
    print("GET BRUTE JSON DEBUG : ");
    var inventory = await _getInventory();
    print(await inventory.readAsString());
  }

  // Affiche dans la console la liste de tout les fichiers présent dans l'emplacement de sauvegarde dédié de l'app.
  static void getAllFileDebug() async {
    print("GET ALL FILES DEBUG : ");
    final directory = await getApplicationDocumentsDirectory();
    int count = 0;

    Directory(directory.path).list().forEach((element) {
      print("Files[$count] : ${element.path}");
      count++;
    });
  }

  static Future<bool> addFileToServer(String path, String fileName) async {
    // Ajout en local du fichier
    final directory = await getApplicationDocumentsDirectory();
    var newPath = "${directory.path}/$fileName";
    File(path).copy(newPath);

    // Requete au serveur pour envoyer le support de cours à ajouter
    var queryParameters = {
      'fileName': fileName,
      'matiere': 'Affaires internationales',
      'level': 'Débutant',
    };
    var uri =
        Uri.https(serverAutority, "$serverBaseUrl/Cours", queryParameters);

    var response = await http.post(uri,
        headers: {
          HttpHeaders.authorizationHeader:
              'bearer ${AppPreferences().login_access_token}',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: File(path).readAsBytesSync());

// Ajouter le fichier en local dans le json si il est validé
    if (response.statusCode == 200) {
      // sauvegarde du fichier dans le stockage interne de l'application.
      _addFileToJsonInventory(int.parse(response.body), fileName,
          "Affaires internationales", "Débutant", newPath, 0, true, true);
      return true;
    } else {
      return false;
    }
  }

  // Ajoute un PDF en local et l'ajoute dans le JSON inventaire.
  static Future<bool> addFileFromServer(
      int id,
      String fileName,
      String matiere,
      String level,
      int accessibility,
      bool downloaded,
      bool freemiumAccess) async {
    final directory = await getApplicationDocumentsDirectory();
    fileName = _validateFileName(fileName);
    var path = "${directory.path}/$id.pdf";

// Requete au serveur
    final url =
        Uri.parse("$serverHttp$serverBaseUrl/Cours/DownloadOneCours?id=$id");
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${AppPreferences().login_access_token}',
      },
    );

// Traitement de la réponse.
    if (response.statusCode == 200) {
      await File(path).writeAsBytes(response.bodyBytes);

      // Mise à jour du fichier JsonInventory
      CoursPdfHandler.editFileOnJsonInventory(id, downloaded: true, path: path);

      return true;
    } else {
      return false;
    }
  }

  // Supprime un objet CoursPdf dans le fichier JSON inventory.
  static void deleteFileToJsonInventory(int id) async {
    // On récupère les cours déjà présent
    var inventory = await _getInventory();
    var allCours = await getJsonInventory();
    // On supprime le cours ciblé.
    allCours.removeWhere((element) => element.id == id);
    // On écrase le fichier avec toutes les nouvelles valeurs.
    await inventory.writeAsString(CoursPdf.toJsonEncodedList(allCours));
  }

  static void deleteAllFilesInJsonInventory() async {
    var inventory = await _getInventory();
    inventory.delete();
  }

  static void deleteSupportOnTheServer(int id) async {
    var queryParameters = {'id': '$id'};
    var uri = Uri.https(serverHttp, "$serverBaseUrl/Cours", queryParameters);

    await http.delete(uri, headers: {
      HttpHeaders.authorizationHeader:
          'bearer ${AppPreferences().login_access_token}',
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  static void deleteDownloadedSupportLocaly(int id) async {
    // On récupère les cours déjà présent
    var inventory = await _getInventory();
    var allCours = await getJsonInventory();
    // On supprime le cours ciblé et sa variable download
    if (allCours.any((element) => element.id == id)) {
      var thisCours = allCours.where((element) => element.id == id).first;
      thisCours.downloaded = false;

      if (await File(thisCours.path).exists()) {
        File(thisCours.path).delete();
      }
    }
    // On écrase le fichier avec toutes les nouvelles valeurs.
    await inventory.writeAsString(CoursPdf.toJsonEncodedList(allCours));
  }

// Permet de modifier les valeurs d'un fichier local en le repérant via son nom.
  static void editFileOnJsonInventory(int id,
      {String? fileName,
      String? matiere,
      String? level,
      String? path,
      int? accessibility,
      bool? downloaded,
      bool? freemiumAccess}) async {
    // Vérification si le potentiel nouveau nom est valide.
    if (fileName != null) fileName = _validateFileName(fileName);

    // On récupère les cours déjà présent
    var inventory = await _getInventory();
    var allCours = await getJsonInventory();

// Si l'id demandé correspond bien à un cours de la liste local, modifie les valeurs non null en parametre.
    if (allCours.any((element) => element.id == id)) {
      var coursToEdit = allCours.where((element) => element.id == id).first;
      if (fileName != null) coursToEdit.name = fileName;
      if (matiere != null) coursToEdit.matiere = matiere;
      if (level != null) coursToEdit.level = level;
      if (path != null) coursToEdit.path = path;
      if (accessibility != null) coursToEdit.accessibility = accessibility;
      if (downloaded != null) coursToEdit.downloaded = downloaded;
      if (freemiumAccess != null) coursToEdit.freemiumAccess = freemiumAccess;
    }

    // On écrase le fichier avec les anciennes et la nouvelle valeur.
    await inventory.writeAsString(CoursPdf.toJsonEncodedList(allCours));
  }
}

// Vérifie si le filename possède l'extention .pdf, si il ne l'a pas, le modifie et le retourne avec l'extention.
String _validateFileName(String fileName) {
  if (!fileName.contains(".pdf")) fileName += ".pdf";
  return fileName;
}
