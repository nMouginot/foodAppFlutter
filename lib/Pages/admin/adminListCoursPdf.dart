// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../Model/cours_pdf_model.dart';
import '../coursPDF/add_cours.dart';
import '../coursPDF/cours_pdf_handler.dart';
import '../coursPDF/display_pdf.dart';

class AdminDisplayCoursPdf extends StatefulWidget {
  const AdminDisplayCoursPdf({Key? key}) : super(key: key);

  @override
  _AdminDisplayCoursPdfState createState() => _AdminDisplayCoursPdfState();
}

class _AdminDisplayCoursPdfState extends State<AdminDisplayCoursPdf> {
  List<CoursPdf> allCours = [];
  List<CoursPdf> displayedCours = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

// Initialise la liste de tout les cours et met a jour la liste d'affichage en fonction des filtres utilisés.
  void _refreshData() {
    CoursPdfHandler.getJsonInventory().then((result) {
      setState(() {
        allCours = result;
      });
    });

    // Tout les filtres sont appliqués ici puis retourne le résultat dans la liste "displayedCours"
    displayedCours = allCours;
  }

  void _deleteCours(int id) {}

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

    // Si la liste est vide, affiche un texte.
    if (allCours.isEmpty) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          hoverColor: Colors.orange[50],
          hoverElevation: 50,
          child: const Icon(Icons.add),
          tooltip: "Ajouter un cours",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCoursForm(),
                ));
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Les cours"),
        ),
        body: const Center(child: Text("Aucun cours trouvé.")),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.orange[50],
        hoverElevation: 50,
        child: const Icon(Icons.add),
        tooltip: "Ajouter un cours",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCoursForm(),
              ));
        },
      ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayPDF(
                                    filePath: element.path,
                                    fileName: element.name),
                              ))
                        },
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                trailing: IconButton(
                                  onPressed: () {
                                    _deleteCours(element.id);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.grey,
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
