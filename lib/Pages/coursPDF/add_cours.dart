import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../handler_json/cours_pdf_handler.dart';

class AddCoursForm extends StatefulWidget {
  const AddCoursForm({Key? key}) : super(key: key);

  @override
  _AddCoursFormState createState() => _AddCoursFormState();
}

class _AddCoursFormState extends State<AddCoursForm> {
  final _formKey = GlobalKey<FormState>();
  final inputName = TextEditingController();

  FilePickerResult? selectedFile;
  String filePath = "";

// Si un fichier est selectionné, modifie le Input name si il est vide.
  void updateDataWithFileSelected() {
    if (selectedFile != null && inputName.text.isEmpty) {
      inputName.text = selectedFile?.names.first ?? "";
    }
  }

  String? validatorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

// Lors du clic sur le bouton de validation, vérifie que tous les validator sont bon puis enregistre le PDF sur le serveur et en local.
  Future<void> saveNewPdf() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      filePath = selectedFile?.files.first.path ?? "";

      await CoursPdfHandler.addFileToServer(filePath, inputName.text);

      inputName.text = "";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(milliseconds: 700),
            content: Text('Ajout de support de cours valide.')),
      );
    }
  }

  // --------------------------------------------------
  //              Partie Graphique/Affichage
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un nouveau cours"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: saveNewPdf,
        ),
        body: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Spacer(flex: 1),
                  // Input nom du cours
                  TextFormField(
                      controller: inputName,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Nom du cours'),
                      validator: validatorName),
                  const Spacer(),
                  // Input matière
                  // TODO a remplacer par un dropdown
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Matière du cours'),
                  ),
                  const Spacer(),
                  // Input niveau
                  // TODO a remplacer par un dropdown
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Niveau du cours à ajouter'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async => {
                            selectedFile =
                                await FilePicker.platform.pickFiles(),
                            updateDataWithFileSelected()
                          },
                      child: const Text("Selectionner le support de cours")),
                  const Spacer(flex: 5),
                ],
              ),
            )));
  }
}
