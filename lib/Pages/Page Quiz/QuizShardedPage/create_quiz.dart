import 'package:flutter/material.dart';
import 'package:flutter_food_app/Components/c_header1.dart';
import 'package:flutter_food_app/Mock%20Data/Matiere.dart';
import 'package:flutter_food_app/Mock%20Data/Niveaux.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/create_quiz_graded_questions.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizTraining/create_quiz_training_questions.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

class CreateQuiz extends StatefulWidget {
  final List<Matieres> _matieres = sample_data_matieres
      .map((json) => Matieres(value: json['matiere']))
      .toList();

  final List<Niveaux> _niveaux = sample_data_niveaux
      .map((json) => Niveaux(value: json['niveau']))
      .toList();

  late String dropdownMatiereValue;
  late List<DropdownMenuItem<String>> dropdownMatieresItems;
  late String dropdownNiveauValue;
  late List<DropdownMenuItem<String>> dropdownNiveauItems;

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

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();

  bool quizIstraining = true;

  String matiereSelected = "";

  String niveauSelected = "";

  TextEditingController quizNomController = TextEditingController();

  TextEditingController quizTimerController = TextEditingController();

  void matiereDropdown(String? textSelected) {
    matiereSelected =
        (textSelected != null) ? textSelected : widget.dropdownMatiereValue;
  }

  void niveauDropdown(String? textSelected) {
    niveauSelected =
        (textSelected != null) ? textSelected : widget.dropdownNiveauValue;
  }

// Lors du clic sur le bouton de validation, vérifie que tous les validator sont bon puis enregistre le PDF sur le serveur et en local.
  Future<void> saveNewQuiz(BuildContext context) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      if (matiereSelected.isEmpty) {
        matiereSelected = widget.dropdownMatiereValue;
      }
      if (niveauSelected.isEmpty) {
        niveauSelected = widget.dropdownNiveauValue;
      }

      int addedQuizId = await QuizHandler.addQuizToQinvWithGeneratedId(
          coefficient: 1,
          creationDate: DateTime.now(),
          isTraining: quizIstraining,
          matiere: matiereSelected,
          name: quizNomController.value.text,
          niveau: niveauSelected,
          timerQuiz: int.parse(quizTimerController.value.text));

      if (quizIstraining) {
        // Le pop permet de sortir cette page de la pile de navigation avant de passer sur la page de création des questions. Cela permet de faire un retour sur le page home directement.
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CreateQuizTrainingQuestion(quizId: addedQuizId)));
      } else {
        // Le pop permet de sortir cette page de la pile de navigation avant de passer sur la page de création des questions. Cela permet de faire un retour sur le page home directement.
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CreateQuizGradedQuestion(quizId: addedQuizId)));
      }
    }
  }

//#region build
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints view) {
      return Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: white,
          title: Text(
            "Création de quiz",
            style: TextStyle(
                color: black,
                fontSize: size18,
                fontFamily: "Saira",
                fontWeight: FontWeight.w400),
          ),
        ),
        body: Stack(children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/screen_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
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
                        c_header1(Icons.ballot_sharp, "Informations génériques",
                            context: context),
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
                            style: Theme.of(context).textTheme.headline5),
                        DropdownButtonFormField<String>(
                            value: widget.dropdownMatiereValue,
                            items: widget.dropdownMatieresItems,
                            onChanged: (e) => matiereDropdown(e)),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Niveau",
                              style: Theme.of(context).textTheme.headline5),
                          DropdownButtonFormField<String>(
                              value: widget.dropdownNiveauValue,
                              items: widget.dropdownNiveauItems,
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Quiz noté",
                            style: Theme.of(context).textTheme.bodyText1),
                        Switch(
                          value: quizIstraining,
                          onChanged: (value) {
                            setState(() {
                              quizIstraining = !quizIstraining;
                            });
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                          inactiveTrackColor: Colors.red[200],
                          inactiveThumbColor: Colors.red,
                        ),
                        Text("Quiz d'entrainement",
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: blue11),
                        onPressed: () async => {saveNewQuiz(context)},
                        child: const Text("Ajouter les questions")),
                  ],
                ),
              ),
            ),
          ),
        ]),
      );
    });
  }

  //#endregion
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
}
