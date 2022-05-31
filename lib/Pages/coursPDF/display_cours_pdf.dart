import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../Model/cours_pdf_model.dart';
import 'cours_pdf_handler.dart';
import 'display_pdf.dart';

class DisplayCoursPdf extends StatefulWidget {
  const DisplayCoursPdf({Key? key}) : super(key: key);

  @override
  _DisplayCoursPdfState createState() => _DisplayCoursPdfState();
}

class _DisplayCoursPdfState extends State<DisplayCoursPdf> {
  List<CoursPdf> allCours = [];
  List<CoursPdf> displayedCours = [];

// Initialise la liste de tout les cours et met a jour la liste d'affichage en fonction des filtres utilisés.
  void _refreshData() {
    CoursPdfHandler.getJsonInventory().then((result) {
      setState(() {
        allCours = result;
        displayedCours = allCours;
      });
    });
  }

// Permet de télécharger un support de cours à partir du serveur.
  void downloadCours(int id) async {
    // Téléchargement du cours du serveur via l'id
    debugPrint("Début du Téléchargement. id = $id");

    var result = await CoursPdfHandler.addFileFromServer(
        id, "test", "matiere", "level", 0, true, true);

    debugPrint("Fin du Téléchargement. id = $id");

    if (result) {
      var jsonInventory = await CoursPdfHandler.getJsonInventory();

      setState(() {
        allCours = jsonInventory;
        displayedCours = allCours;
      });
    }

    debugPrint("Téléchargement validé. id = $id");
    CoursPdfHandler.getAllFileDebug();
  }

  void deleteCoursLocaly(int id) async {
    CoursPdfHandler.editFileOnJsonInventory(id, downloaded: false);
    final directory = await getApplicationDocumentsDirectory();
    File("${directory.path}/$id.pdf").delete();

    var jsonInventory = await CoursPdfHandler.getJsonInventory();

    setState(() {
      allCours = jsonInventory;
      displayedCours = allCours;
    });

    debugPrint("Téléchargement annulé. id = $id");
    CoursPdfHandler.getAllFileDebug();
  }

  // --------------------------------------------------
  //              Partie Graphique/Affichage
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // Je pense que c'est la pire façon de refresh les données mais bon ça fonctionne ...
    if (displayedCours.isEmpty) {
      _refreshData();
    }

    // Si la liste est vide, affiche un texte.
    if (allCours.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Les cours"),
        ),
        body: const Center(child: Text("Aucun cours trouvé.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Les cours"),
      ),
      body: Container(
          margin: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
                children: displayedCours
                    .map(
                      (element) => GestureDetector(
                        onTap: () => {
                          if (element.downloaded)
                            {
                              print("ELEMENT PATH : ${element.path}"),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DisplayPDF(
                                        filePath: element.path,
                                        fileName: element.name),
                                  ))
                            }
                        },
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                trailing: Column(
                                  children: [
                                    Visibility(
                                      visible: element.downloaded,
                                      child: IconButton(
                                        onPressed: () {
                                          deleteCoursLocaly(element.id);
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Visibility(
                                      visible: !element.downloaded,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          downloadCours(element.id);
                                        },
                                        child: const Text("Télécharger"),
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(element.name),
                                subtitle: Text(
                                    "Matiere : ${element.matiere}\n \t Niveau : ${element.level}"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList()),
          )),
    );
  }
}
