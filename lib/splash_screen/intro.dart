import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/checkerboard.dart';
import 'package:todai/splash_screen/robocaptcha.dart';

class IntroSequence extends StatefulWidget {
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  const IntroSequence(
      {super.key, required this.dimensions, required this.onFinished});

  @override
  State<IntroSequence> createState() => _IntroSequenceState();
}

enum SplashSequenceStep {
  one,
  two,
  three,
}

class _IntroSequenceState extends State<IntroSequence> {
  SplashSequenceStep step = SplashSequenceStep.one;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case SplashSequenceStep.one:
        return AnimatedCheckerboard(
            dimensions: widget.dimensions,
            onFinished: () => setState(() => step = SplashSequenceStep.two),
            pattern: CheckerboardPattern.lightToDark);
      case SplashSequenceStep.two:
        return RoboCaptcha(
            dimensions: widget.dimensions,
            onFinished: () => setState(() => step = SplashSequenceStep.three));
      case SplashSequenceStep.three:
        return AnimatedCheckerboard(
            dimensions: widget.dimensions,
            onFinished: () => widget.onFinished(),
            pattern: CheckerboardPattern.darkToLight);
    }
  }
}
