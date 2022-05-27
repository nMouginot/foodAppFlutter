import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MainModule.dart';
import 'package:flutter_food_app/Model/ModuleId.dart';
import 'package:flutter_food_app/Model/Quiz.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/QuizShardedPage/play_quiz.dart';
import 'package:flutter_food_app/Pages/handler_json/module_handler.dart';
import 'package:flutter_food_app/Pages/handler_json/quiz_handler.dart';
import 'package:flutter_food_app/Pages/handler_json/user_result_handler.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

class ListModule extends StatefulWidget {
  ListModule({Key? key, required this.mainModule}) : super(key: key);

  /// MainModule ouvert
  MainModule mainModule;

  @override
  _ListModuleState createState() => _ListModuleState();
}

class _ListModuleState extends State<ListModule> {
  /// Liste des quizs présents dans ce mainModule.
  late List<Quiz> quizModules;

  /// Liste des cours présents dans ce mainModule.
  // late List<Cours> CoursModules;

  @override
  void initState() {
    quizModules = List<Quiz>.empty(growable: true);
    getModules();
    super.initState();
  }

  /// Lance un quiz et met à jour la page au retour pour pouvoir changer l'apparence du module si il est complété.
  Future<void> startQuizAndUpdatePageAtTheEnd(
      Quiz quiz, BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlayQuiz(parameterQuiz: quiz)));

    setState(() {
      debugPrint(
          "Recalcule"); // Ne pas supprimer ou la mise à jour ne fonctionne plus pour des raisons magiques.
      quizModules = List<Quiz>.empty(growable: true);
      getModules();
    });
  }

  /// Recupère les modules du mainModule et les ajoutes dans les listes de modules correspondante.
  Future<void> getModules() async {
    for (var moduleId in widget.mainModule.modulesId) {
      switch (moduleId.type) {
        case ModuleType.indefini:
          break;

        // Si c'est un [Quiz], le récupère depuis la liste local et l'ajout dans [quizModules]
        case ModuleType.quiz:
          Quiz? quiz = await QuizHandler.getQuizById(moduleId.id);

          // Si il y a un bien un quiz, vérifie que l'utilisateur ne l'a pas déjà fait. Si oui, vérifie si il ne l'a pas déjà validé.
          if (quiz != null) {
            List<Quiz>? userQuizs =
                await UserResultHandler.getQuizResultByQuizId(moduleId.id);

            if (userQuizs != null && userQuizs.isNotEmpty) {
              quiz.moduleValidated = Quiz.validateQuizModule(userQuizs, 10);
            }

            quizModules.add(quiz);
          }

          break;

        // TODO à faire quand les cours serons fusionnés.
        case ModuleType.cours:
          break;

        default:
      }

      // Met à jour l'affichage après que l'on est fini de mettre à jour les listes de modules.
      setState(() {});
    }
  }

  /// Code qui est lu juste avant de quitter la page.
  Future<bool> leavePage(BuildContext context) async {
    int numberOfQuizValidated = 0;
    for (var quiz in quizModules) {
      if (quiz.moduleValidated) numberOfQuizValidated++;
    }

    await ModuleHandler.changeMainModuleCompletionById(widget.mainModule.id,
        (numberOfQuizValidated / quizModules.length * 100).round());

    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints view) {
      return WillPopScope(
        onWillPop: () => leavePage(context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 5.0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      leavePage(context);
                    });
                  },
                  child: Image.asset(
                    "assets/images/icons/back_arrow.png",
                    width: size24,
                    height: size22,
                  )),
            ),
            title: Text(
              widget.mainModule.name,
              style: TextStyle(
                  color: black,
                  fontSize: size18,
                  fontFamily: "Saira",
                  fontWeight: FontWeight.w400),
            ),
          ),
          body: Stack(
            children: [
              Container(
                width: view.maxWidth,
                height: view.maxHeight,
                child: Image.asset(
                  "assets/images/screen_bg.png",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  child: (quizModules.isNotEmpty)
                      ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: size30, left: size20, right: size20),
                          itemCount: quizModules.length,
                          itemBuilder: (context, index) {
                            final module = quizModules[index];
                            final String indexText =
                                (index < 9) ? "0${index + 1}" : "${index + 1}";
                            return GestureDetector(
                              onTap: () => {
                                startQuizAndUpdatePageAtTheEnd(module, context)
                              },
                              child: cardListDetails(
                                  module,
                                  "${module.name}\nMatière : ${module.matiere}\nNiveau : ${module.niveau}",
                                  module.questions.length,
                                  module.totalTimerMinutes,
                                  module.moduleValidated,
                                  view.maxWidth,
                                  indexText),
                            );
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgressIndicator()]))
            ],
          ),
        ),
      );
    });
  }
}

Widget cardListDetails(Quiz quiz, String description, int question, int min,
    bool check, double width, String indexText) {
  return Container(
    width: width, //view.maxWidth,
    height: size200,
    margin: EdgeInsets.only(bottom: size20),
    padding: EdgeInsets.only(
      top: check ? size10 : size20,
      //left: check ? size20 : size35,
    ),
    decoration: BoxDecoration(color: check ? blue11 : white, boxShadow: [
      BoxShadow(
          color: black.withOpacity(0.2),
          spreadRadius: 1.0,
          blurRadius: 4,
          offset: const Offset(0.0, 3.0))
    ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: check ? 0 : size15,
          ),
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image.asset(
                    check
                        ? "assets/images/icons/greycircle1.png"
                        : "assets/images/icons/bluecircle1.png",
                    width: check ? size120 : size90,
                    height: check ? size120 : size90,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: size10),
                    child: Text(
                      indexText,
                      style: TextStyle(
                          color: check ? blue11 : white,
                          fontSize: size26,
                          fontFamily: "Saira",
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: check ? 0 : size20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (quiz.isTraining) ? "Quiz d'entrainement" : "Quiz évalué",
                    style: TextStyle(
                        color: check ? white : black,
                        fontSize: size22,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                        color: check ? white : black,
                        fontSize: size16,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: check ? 0 : size20,
        ),
        Divider(
          color: check ? white : black,
          thickness: 1.0,
          indent: size120,
        ),
        SizedBox(
          height: size10,
        ),
        Padding(
          padding:
              EdgeInsets.only(left: check ? size100 : size90, right: size13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/icons/message.png",
                width: size20,
                height: size20,
                color: check ? white : black,
              ),
              SizedBox(
                width: size10,
              ),
              Text(
                "${question} Questions",
                style: TextStyle(
                    color: check ? white : black,
                    fontSize: size14,
                    fontFamily: "Saira",
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                width: size30,
              ),
              Image.asset(
                "assets/images/icons/timer.png",
                width: size20,
                height: size20,
                color: check ? white : black,
              ),
              SizedBox(
                width: size10,
              ),
              Text(
                "${min} Min",
                style: TextStyle(
                    color: check ? white : black,
                    fontSize: size14,
                    fontFamily: "Saira",
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
