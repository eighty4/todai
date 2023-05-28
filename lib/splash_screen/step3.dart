import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'step1.dart';

class IntroStep3 extends StatefulWidget {
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  const IntroStep3(
      {super.key, required this.dimensions, required this.onFinished});

  @override
  State<IntroStep3> createState() => _IntroStep3State();
}

class _IntroStep3State extends State<IntroStep3> {
  late final List<AnimatedCheckerBox> boxes;

  @override
  void initState() {
    super.initState();
    boxes = calculateAnimationWithBug(widget.dimensions);
    Future.delayed(Duration(milliseconds: (durationMS / 2).floor()), () {
      TodaiBackground.of(context).dark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.dimensions.devicePadding.top),
      child: GestureDetector(
          child: Stack(children: boxes),
          onTap: () {
            widget.onFinished();
          }),
    );
  }
}
