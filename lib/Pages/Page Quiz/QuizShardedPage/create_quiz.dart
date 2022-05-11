import 'package:flutter/material.dart';
import 'package:flutter_food_app/Mock%20Data/Matiere.dart';
import 'package:flutter_food_app/Mock%20Data/Niveaux.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/create_quiz_training_questions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/quiz_handler.dart';
import 'package:flutter_food_app/Tools/c_divider1.dart';
import 'package:flutter_food_app/Tools/c_header1.dart';

class CreateQuiz extends StatelessWidget {
  //#region Variables & constructor
  final _formKey = GlobalKey<FormState>();

  late String dropdownMatiereValue;
  late List<DropdownMenuItem<String>> dropdownMatieresItems;
  final List<Matieres> _matieres = sample_data_matieres
      .map((json) => Matieres(value: json['matiere']))
      .toList();

  late String dropdownNiveauValue;
  late List<DropdownMenuItem<String>> dropdownNiveauItems;
  final List<Niveaux> _niveaux = sample_data_niveaux
      .map((json) => Niveaux(value: json['niveau']))
      .toList();

  CreateQuiz({Key? key}) : super(key: key) {
    dropdownMatiereValue = _matieres[0].value;
    dropdownMatieresItems = _matieres
        .map((e) => DropdownMenuItem(child: Text(e.value), value: e.value))
        .toList();

    dropdownNiveauValue = _niveaux[0].value;
    dropdownNiveauItems = _niveaux
        .map((e) => DropdownMenuItem(child: Text(e.value), value: e.value))
        .toList();
  }
  //#endregion

  String matiereSelected = "";
  String niveauSelected = "";
  TextEditingController quizNomController = TextEditingController();
  TextEditingController quizTimerController = TextEditingController();

  void matiereDropdown(String? textSelected) {
    matiereSelected =
        (textSelected != null) ? textSelected : dropdownMatiereValue;
  }

  void niveauDropdown(String? textSelected) {
    niveauSelected =
        (textSelected != null) ? textSelected : dropdownNiveauValue;
  }

// Lors du clic sur le bouton de validation, vérifie que tous les validator sont bon puis enregistre le PDF sur le serveur et en local.
  Future<void> saveNewQuiz(BuildContext context) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      if (matiereSelected.isEmpty) {
        matiereSelected = dropdownMatiereValue;
      }
      if (niveauSelected.isEmpty) {
        niveauSelected = dropdownNiveauValue;
      }

      int addedQuizId = await QuizHandler.addQuizToQinvWithGeneratedId(
          coefficient: 1,
          creationDate: DateTime.now(),
          isTraining: true,
          matiere: matiereSelected,
          name: quizNomController.value.text,
          niveau: niveauSelected,
          timerQuiz: int.parse(quizTimerController.value.text));

      if (true) {
        // TODO Modifier le true de ce if par la valeur d'un bouton (A ajouter a la page) pour choisir si le quiz est en mode training ou graded.
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateQuizQuestion(quizId: addedQuizId)));
      } else {
        // TODO navigation vers la future page pour les graded quiz
      }
    }
  }

//#region build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un quiz"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    c_header1(Icons.ballot_sharp, "Informations générique",
                        context: context),
                    c_divider1(),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: quizNomController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Nom du quiz'),
                    validator: validatorQuizName),
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Matiere",
                        style: Theme.of(context).textTheme.headline4),
                    DropdownButtonFormField<String>(
                        value: dropdownMatiereValue,
                        items: dropdownMatieresItems,
                        onChanged: (e) => matiereDropdown(e)),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Niveau",
                          style: Theme.of(context).textTheme.headline4),
                      DropdownButtonFormField<String>(
                          value: dropdownNiveauValue,
                          items: dropdownNiveauItems,
                          onChanged: (e) => niveauDropdown(e)),
                    ]),
                const SizedBox(height: 40),
                TextFormField(
                    controller: quizTimerController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Temps entre les questions (Secondes)'),
                    validator: validatorQuizTimer),
                // TODO ToogleButton utilisable pour autre chose ?
                // ToggleButtons(children: <Widget>[
                //   Container(
                //       padding: const EdgeInsets.all(10),
                //       child: const Text("Quiz entrainement")),
                //   Container(
                //       padding: const EdgeInsets.all(10),
                //       child: const Text("Quiz noté")),
                // ], isSelected: const [
                //   true,
                //   false
                // ]),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed: () async => {saveNewQuiz(context)},
                    child: const Text("Ajouter les questions")),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //#endregion

//#region Validator
  String? validatorQuizName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? validatorQuizTimer(String? value) {
    if (value != null && value.isNotEmpty) {
      var valueParsed = int.tryParse(value, radix: 10);

      if (valueParsed != null && valueParsed <= 10) {
        return 'Please input a value greater than 9';
      } else if (valueParsed == null) {
        return 'Please enter a number';
      }
    } else {
      return 'Please enter a value';
    }
    return null;
  }
//#endregion
}
