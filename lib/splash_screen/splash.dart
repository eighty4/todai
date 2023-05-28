import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/step1.dart';
import 'package:todai/splash_screen/step2.dart';
import 'package:todai/splash_screen/step3.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case SplashSequenceStep.one:
        return IntroStep1(
            dimensions: widget.dimensions,
            onFinished: () => setState(() => step = SplashSequenceStep.two));
      case SplashSequenceStep.two:
        return IntroStep2(
            dimensions: widget.dimensions,
            onFinished: () => setState(() => step = SplashSequenceStep.three));
      case SplashSequenceStep.three:
        return IntroStep3(
            dimensions: widget.dimensions,
            onFinished: () => widget.onFinished());
    }
  }
}
