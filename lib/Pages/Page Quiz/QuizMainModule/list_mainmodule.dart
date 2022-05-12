import 'package:flutter/material.dart';
import 'package:flutter_food_app/Model/MainModule.dart';
import 'package:flutter_food_app/Pages/Page%20Quiz/module_handler.dart';
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
  Stream<List<MainModule>> getMainModuleStream = (() async* {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    yield await ModuleHandler.getInvValue();
  })();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MainModule>>(
      stream: getMainModuleStream,
      initialData: List<MainModule>.empty(growable: true),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<MainModule>> listMainModules,
      ) {
        if (listMainModules.connectionState == ConnectionState.waiting) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator()]);
        } else {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints view) {
              Align startButton = Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // TODO navigation to listModule
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleScreen1()));
                    });
                  },
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

              Container cardListDetails(
                  String name, int module, int percentage, String description) {
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
                                name,
                                style: TextStyle(
                                    color: black,
                                    fontSize: size20,
                                    fontFamily: "Saira",
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "${module} Modules",
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
                            percent: (percentage / 100),
                            center: Text(
                              "${percentage}%",
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
                          description,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: TextStyle(
                              color: black,
                              fontSize: size16,
                              fontFamily: "Saira",
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      startButton,
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
                    Container(
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
                      itemCount: listMainModules.data?.length,
                      itemBuilder: (context, index) {
                        final mainModule =
                            listMainModules.data?[index] as MainModule;
                        return cardListDetails(
                            mainModule.name,
                            mainModule.numberOfModule,
                            mainModule.completionOfTheMainModule,
                            mainModule.definition);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
