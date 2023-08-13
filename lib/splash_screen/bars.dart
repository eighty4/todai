import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/boxes.dart';

class AnimatedBars extends StatefulWidget {
  final BoxesGrid boxesGrid;
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  const AnimatedBars(
      {super.key,
      required this.boxesGrid,
      required this.dimensions,
      required this.onFinished});

  @override
  State<AnimatedBars> createState() => _AnimatedBarsState();
}

class _AnimatedBarsState extends State<AnimatedBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Map<double, Animation<double>> _bars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..addListener(() {
        if (_controller.isCompleted) {
          TodaiBackground.of(context).dark();
          Future.delayed(const Duration(milliseconds: 600), widget.onFinished);
        }
      });
    _bars = createBarAnimations(
        _controller, widget.dimensions.windowSize, widget.boxesGrid.boxSize);
    _controller.animateTo(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _bars.entries.map((e) {
        return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _bars[e.key]!.value,
                top: e.key,
                child: Container(
                    height: widget.boxesGrid.boxSize.height,
                    width: widget.dimensions.windowSize.width,
                    color: Colors.black),
              );
            });
      }).toList(),
    );
  }
}

Map<double, Animation<double>> createBarAnimations(
    AnimationController controller, Size windowSize, Size boxSize) {
  // const intervalWaveBegin = .2;
  // const intervalStep = .075;
  // const intervalEnd = .5;

  final bars = HashMap<double, Animation<double>>();
  // double beginIntervalFn(int i) => min(1, intervalWaveBegin + (i * intervalStep));
  // double endIntervalFn(int i) => min(1, intervalEnd + (i * intervalStep));

  final middleBarPositionFromTop =
      (windowSize.height / 2) + (boxSize.height / 2);
  // final numberOfBars = (windowSize.height / boxSize.height).round();
  // final halfOfBars = (numberOfBars / 2) + 1;

  const animationDuration = .05;
  const intervalBeginStep = .05;
  const firstWaveIntervalBegin = .2;
  const secondWaveIntervalBegin = .5;

  bars[middleBarPositionFromTop] = createBarAnimation(
      controller,
      windowSize.width,
      firstWaveIntervalBegin,
      firstWaveIntervalBegin + animationDuration);

  double positionStep = boxSize.height * 2;
  int i;

  // first wave

  i = 1;
  for (double nextBarPositionFromTop = middleBarPositionFromTop + positionStep;
      nextBarPositionFromTop < windowSize.height;
      nextBarPositionFromTop += positionStep) {
    double intervalStart = firstWaveIntervalBegin + (i * intervalBeginStep);
    bars[nextBarPositionFromTop] = createBarAnimation(
        controller,
        windowSize.width,
        intervalStart,
        min(1, intervalStart + animationDuration));
    i++;
  }

  i = 1;
  for (double nextBarPositionFromTop = middleBarPositionFromTop - positionStep;
      nextBarPositionFromTop > -1;
      nextBarPositionFromTop -= positionStep) {
    double intervalStart = firstWaveIntervalBegin + (i * intervalBeginStep);
    bars[nextBarPositionFromTop] = createBarAnimation(
        controller,
        windowSize.width,
        intervalStart,
        min(1, intervalStart + animationDuration));
    i++;
  }

  // second wave

  i = 1;
  for (double nextBarPositionFromTop =
          middleBarPositionFromTop + boxSize.height;
      nextBarPositionFromTop < windowSize.height;
      nextBarPositionFromTop += positionStep) {
    double intervalStart = secondWaveIntervalBegin + (i * intervalBeginStep);
    bars[nextBarPositionFromTop] = createBarAnimation(
        controller,
        -1 * windowSize.width,
        intervalStart,
        min(1, intervalStart + animationDuration));
    i++;
  }

  i = 1;
  for (double nextBarPositionFromTop =
          middleBarPositionFromTop - boxSize.height;
      nextBarPositionFromTop > -1;
      nextBarPositionFromTop -= positionStep) {
    double intervalStart = secondWaveIntervalBegin + (i * intervalBeginStep);
    bars[nextBarPositionFromTop] = createBarAnimation(
        controller,
        -1 * windowSize.width,
        intervalStart,
        min(1, intervalStart + animationDuration));
    i++;
  }

  return bars;
}

Animation<double> createBarAnimation(AnimationController controller,
    double offScreenPosition, double iStart, double iEnd) {
  return Tween<double>(begin: offScreenPosition, end: 0).animate(
    CurvedAnimation(
      parent: controller,
      curve:
          Interval(min(1, iStart), min(1, iEnd), curve: Curves.easeInOutQuad),
    ),
  );
}
