import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MainModule.dart';
import 'package:flutter_food_app/Pages/MainModule&Module/list_module.dart';
import 'package:flutter_food_app/Pages/handler_json/module_handler.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/strings.dart';
import 'package:flutter_food_app/utils/uicolors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ListMainModule extends StatefulWidget {
  const ListMainModule({Key? key}) : super(key: key);

  @override
  _ListMainModuleState createState() => _ListMainModuleState();
}

class _ListMainModuleState extends State<ListMainModule> {
  List<MainModule> listMainModule = List<MainModule>.empty();

  @override
  void initState() {
    setupListMainModule().then((o) {
      setState(() {});
    });

    super.initState();
  }

  /// Permet de récupérer la liste des MainModules stocker en local
  Future setupListMainModule() async {
    listMainModule = await ModuleHandler.getMInvValue();
    return true;
  }

  /// Navigue sur les modules du main module selectionner et met à jour la liste au retour pour afficher correctement la completion.
  void navigateToListModule(MainModule mainModule) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListModule(mainModule: mainModule),
      ),
    );

    setupListMainModule().then((o) {
      setState(() {
        for (var element in listMainModule) {
          print(element);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (listMainModule.isEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [CircularProgressIndicator()])
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints view) {
              Align startButton = Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: InkWell(
                  child: Container(
                    width: size130,
                    height: size40,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(size30)),
                        gradient: LinearGradient(
                          colors: [blue11, blue12],
                          begin: AlignmentDirectional.topCenter,
                          end: AlignmentDirectional.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 4,
                              offset: const Offset(0.0, 3.0))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/icons/play.png",
                          width: size16,
                          height: size16,
                        ),
                        SizedBox(
                          width: size10,
                        ),
                        Text(
                          startButtonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: white,
                              fontSize: size22,
                              fontFamily: "Saira",
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              Container cardListDetails(MainModule mainModule) {
                return Container(
                  width: view.maxWidth,
                  height: 200,
                  margin: EdgeInsets.only(bottom: size20),
                  padding:
                      EdgeInsets.only(top: size10, left: size20, right: size20),
                  decoration: BoxDecoration(color: white, boxShadow: [
                    BoxShadow(
                        color: black.withOpacity(0.3),
                        spreadRadius: 1.0,
                        blurRadius: 4,
                        offset: const Offset(0.0, 3.0))
                  ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mainModule.name,
                                style: TextStyle(
                                    color: black,
                                    fontSize: size20,
                                    fontFamily: "Saira",
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${mainModule.numberOfModule} Modules",
                                style: TextStyle(
                                    color: grey11,
                                    fontSize: size16,
                                    fontFamily: "Saira",
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent:
                                (mainModule.completionOfTheMainModule / 100),
                            center: Text(
                              "${mainModule.completionOfTheMainModule}%",
                              style: TextStyle(
                                  color: black,
                                  fontSize: size16,
                                  fontFamily: "Saira",
                                  fontWeight: FontWeight.w400),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: blue11,
                            animationDuration: 2000,
                          )
                        ],
                      ),
                      SizedBox(
                        height: size10,
                      ),
                      Expanded(
                        child: Text(
                          mainModule.definition,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: TextStyle(
                              color: black,
                              fontSize: size16,
                              fontFamily: "Saira",
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            navigateToListModule(mainModule);
                          });
                        },
                        child: startButton,
                      ),
                      SizedBox(
                        height: size15,
                      ),
                    ],
                  ),
                );
              }

              return Scaffold(
                appBar: AppBar(
                  elevation: 5.0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: white,
                  title: Text(
                    coursesText,
                    style: TextStyle(
                        color: black,
                        fontSize: size18,
                        fontFamily: "Saira",
                        fontWeight: FontWeight.w400),
                  ),
                ),
                body: Stack(
                  children: [
                    SizedBox(
                      width: view.maxWidth,
                      height: view.maxHeight,
                      child: Image.asset(
                        "assets/images/screen_bg.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    ListView.builder(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 25),
                      itemCount: listMainModule.length,
                      itemBuilder: (context, index) {
                        final mainModule = listMainModule[index];
                        return cardListDetails(mainModule);
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }
}
