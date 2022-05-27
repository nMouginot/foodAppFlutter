import 'dart:async';

import 'package:flutter/material.dart';

class DisplayedTimerByDateUpdated extends StatefulWidget {
  const DisplayedTimerByDateUpdated(
      {Key? key,
      required this.duration,
      required this.startTime,
      required this.maxTimeInHours})
      : super(key: key);

  final Duration duration;
  final DateTime startTime;

  /// Valeur entre 1 et 24 obligatoirements.
  final int maxTimeInHours;

  @override
  _DisplayedTimerByDateUpdatedState createState() =>
      _DisplayedTimerByDateUpdatedState();
}

class _DisplayedTimerByDateUpdatedState
    extends State<DisplayedTimerByDateUpdated> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(widget.duration, (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        "${widget.maxTimeInHours - 1 - (DateTime.now().hour - widget.startTime.hour)}H${60 - (DateTime.now().minute - widget.startTime.minute)}");
  }
}
