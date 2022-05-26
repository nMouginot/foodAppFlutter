import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/ModuleId.dart';
import 'package:flutter_food_app/Model/QuizWithoutQuestions.dart';
import 'package:flutter_food_app/Pages/MainModule/list_select_quiz.dart';
import 'package:flutter_food_app/Pages/handler_json/module_handler.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

class CreateMainModule extends StatefulWidget {
  const CreateMainModule({Key? key}) : super(key: key);

  @override
  State<CreateMainModule> createState() => _CreateMainModuleState();
}

class _CreateMainModuleState extends State<CreateMainModule> {
  final _formKey = GlobalKey<FormState>();

  List<ModuleId> modules = List<ModuleId>.empty(growable: true);
  List<QuizWithoutQuestions> displayedData =
      List<QuizWithoutQuestions>.empty(growable: true);

  TextEditingController moduleNomController = TextEditingController();
  TextEditingController moduleDescriptionController = TextEditingController();

// Lors du clic sur le bouton de validation, vérifie que tous les validator sont bon puis enregistre le PDF sur le serveur et en local.
  Future<void> saveNewMainModule(BuildContext context) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      ModuleHandler.addMainModuleToMInvWithGeneratedId(
          name: moduleNomController.value.text,
          modules: modules,
          definition: moduleDescriptionController.value.text);

// TODO récupérer le fichiers avec tout les modules et faire une comparaison d'id. Si ils ne sont pas existant, créer les nouveaux modules.

      Navigator.of(context).pop();
    }
  }

  void _navigateSelectQuiz(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    QuizWithoutQuestions? quiz = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListSelectQuiz()),
    );

    if (quiz != null) {
      if (modules.any((element) => element.id == quiz.id)) {
        debugPrint("Il y a déjà un module avec cet id d'ajouté");
      } else {
        setState(() {
          modules.add(ModuleId(id: quiz.id, type: ModuleType.quiz));
          displayedData.add(quiz);
        });
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
            "Création de module",
            style: TextStyle(
                color: black,
                fontSize: size18,
                fontFamily: "Saira",
                fontWeight: FontWeight.w400),
          ),
        ),
        body: Stack(children: [
          // ignore: sized_box_for_whitespace
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/screen_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: moduleNomController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Nom du module'),
                        validator: validatorModuleName),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: moduleDescriptionController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Description du module'),
                        validator: validatorModuleName),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: blue11),
                            onPressed: () async => {
                                  _navigateSelectQuiz(context)
                                }, // TODO NAVIGATE TO LIST QUIZ PAGE WITH SELECTION
                            child: const Text("Ajouter un quiz")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: blue11),
                            onPressed:
                                null, // TODO NAVIGATE TO LIST COURS PAGE WITH SELECTION
                            child: const Text("Ajouter des cours")),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: blue11),
                        onPressed: () async => {saveNewMainModule(context)},
                        child: const Text("Créer le nouveau module")),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) => setState(() {
                  if (newIndex > oldIndex) {
                    newIndex--;
                  }

                  final elementMoved = displayedData.removeAt(oldIndex);
                  displayedData.insert(newIndex, elementMoved);
                }),
                itemCount: displayedData.length,
                itemBuilder: (context, index) {
                  final element = displayedData[index];
                  return Card(
                    key: ValueKey(element.id),
                    child: ListTile(
                      title: Text(element.name),
                      onTap: () {
// TODO delete !
                      },
                    ),
                  );
                },
              ),

//                             child: ListView.builder(
//                 itemCount: displayedData.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text(displayedData[index].name),
//                       onTap: () {
// // TODO delete !
//                       },
//                     ),
//                   );
//                 },
//               ),
            )
          ]),
        ]),
      );
    });
  }

  //#endregion
  String? validatorModuleName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
