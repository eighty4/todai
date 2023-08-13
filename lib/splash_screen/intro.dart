import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/bars.dart';
import 'package:todai/splash_screen/boxes.dart';
import 'package:todai/splash_screen/fade.dart';
import 'package:todai/splash_screen/robocaptcha.dart';

class IntroSequence extends StatefulWidget {
  final BoxesGrid boxesGrid;
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  IntroSequence({super.key, required this.dimensions, required this.onFinished})
      : boxesGrid = BoxesGrid.forDimensions(dimensions);

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
    return switch (step) {
      SplashSequenceStep.one => AnimatedBars(
          boxesGrid: widget.boxesGrid,
          dimensions: widget.dimensions,
          onFinished: () => setState(() => step = SplashSequenceStep.two)),
      SplashSequenceStep.two => RoboCaptcha(
          boxesGrid: widget.boxesGrid,
          dimensions: widget.dimensions,
          onFinished: () => setState(() => step = SplashSequenceStep.three)),
      SplashSequenceStep.three => BackgroundFade(
          fadeToBackground: BackgroundMode.light,
          onFinished: widget.onFinished),
    };
  }
}
