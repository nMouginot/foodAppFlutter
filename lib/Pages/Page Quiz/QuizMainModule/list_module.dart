import 'package:flutter/material.dart';
import 'package:flutter_food_app/utils/dimension.dart';
import 'package:flutter_food_app/utils/strings.dart';
import 'package:flutter_food_app/utils/uicolors.dart';

class ListModule extends StatefulWidget {
  @override
  _ListModuleState createState() => _ListModuleState();
}

class _ListModuleState extends State<ListModule> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints view) {
      InkWell cardListDetails(
          int num, String name, int question, int min, bool check) {
        return InkWell(
          onTap: () {
            setState(() {
              // TODO Navigate on quiz selected
            });
          },
          child: Container(
            width: view.maxWidth,
            height: size200,
            padding: EdgeInsets.only(
              top: check ? size10 : size20,
              //left: check ? size20 : size35,
            ),
            decoration:
                BoxDecoration(color: check ? blue11 : white, boxShadow: [
              BoxShadow(
                  color: black.withOpacity(0.2),
                  spreadRadius: 1.0,
                  blurRadius: 4,
                  offset: Offset(0.0, 3.0))
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
                              "0$num",
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
                            "Module 0${num}",
                            style: TextStyle(
                                color: check ? white : black,
                                fontSize: size22,
                                fontFamily: "Saira",
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Info: ${name}",
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
                  padding: EdgeInsets.only(
                      left: check ? size100 : size90, right: size13),
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
          ),
        );
      }

      return Scaffold(
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
                    Navigator.pop(context);
                  });
                },
                child: Image.asset(
                  "assets/images/icons/back_arrow.png",
                  width: size24,
                  height: size22,
                )),
          ),
          title: Text(
            chemistryText,
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
            ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding:
                  EdgeInsets.only(top: size30, left: size20, right: size20),
              children: [
                cardListDetails(01, "Basic Knowledge", 40, 40, true),
                SizedBox(
                  height: size20,
                ),
                cardListDetails(02, "Advance Knowledge", 30, 30, false),
                SizedBox(
                  height: size20,
                ),
                cardListDetails(03, "Basic Knowledge", 25, 25, false),
                SizedBox(
                  height: size20,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
