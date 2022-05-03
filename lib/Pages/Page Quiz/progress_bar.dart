import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class ProgressBar extends StatefulWidget {
  final int timer;
  final Function(int) callback;

  const ProgressBar({Key? key, required this.timer, required this.callback})
      : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState(callback: callback);
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final Function(int) callback;
  _ProgressBarState({required this.callback});

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timer),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          callback(-2);
        }
      });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF3F4768), width: 3),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: [
            // LayoutBuilder provide us the available space for the conatiner
            // constraints.maxWidth needed for our animation
            LayoutBuilder(
              builder: (context, constraints) => Container(
                // from 0 to 1 it takes 60s
                width: constraints.maxWidth * controller.value,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradient,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(controller.value * widget.timer).round()} sec",
                      style: const TextStyle(color: Colors.white),
                    ),
                    SvgPicture.asset(
                      "assets/clock.svg",
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
