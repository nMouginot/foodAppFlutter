// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'display_cours_pdf.dart';

class Cours extends StatefulWidget {
  const Cours({Key? key}) : super(key: key);

  @override
  _CoursState createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  @override
  Widget build(BuildContext context) {
    return const DisplayCoursPdf();
  }
}


/*
return Scaffold(
      appBar: AppBar(
        title: Text('Cours'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Bouton pour la navigation
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => TestPageTimeLine()));
              },
              child: const Text('Test TimeLine'),
            ),

            // Point 1
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: true,
              indicatorStyle: const IndicatorStyle(
                width: 20,
                drawGap: true,
                padding: const EdgeInsets.all(4),
                color: Colors.lightBlueAccent,
              ),
              beforeLineStyle: const LineStyle(
                color: Colors.green,
                thickness: 6,
              ),
            ),

            // Point 2
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              beforeLineStyle: const LineStyle(
                color: Colors.green,
                thickness: 6,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.green,
                thickness: 6,
              ),
              indicatorStyle: const IndicatorStyle(
                width: 20,
                drawGap: true,
                padding: const EdgeInsets.all(4),
                color: Colors.blue,
              ),
            ),

            // Point 3
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              beforeLineStyle: const LineStyle(
                color: Colors.green,
                thickness: 6,
              ),
              indicatorStyle: const IndicatorStyle(
                width: 20,
                drawGap: true,
                padding: const EdgeInsets.all(4),
                color: Colors.blueGrey,
              ),
            ),

            // Point 4
            TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isLast: true,
              beforeLineStyle: const LineStyle(
                color: Colors.green,
                thickness: 6,
              ),
              indicatorStyle: const IndicatorStyle(
                width: 20,
                drawGap: true,
                padding: const EdgeInsets.all(4),
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
*/