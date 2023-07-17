import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/boxes.dart';

const durationMS = 3000;

enum CheckerboardPattern {
  lightToDark,
  darkToLight,
}

class AnimatedCheckerboard extends StatefulWidget {
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;
  final CheckerboardPattern pattern;
  final List<AnimatedCheckerBox> boxes;

  AnimatedCheckerboard(
      {super.key,
      required this.dimensions,
      required this.onFinished,
      required this.pattern})
      : boxes = buildAnimatedBoxes(dimensions, pattern);

  @override
  State<AnimatedCheckerboard> createState() => _AnimatedCheckerboardState();

  static List<AnimatedCheckerBox> buildAnimatedBoxes(
      TodaiDimensions dimensions, CheckerboardPattern pattern) {
    late final Color from;
    late final Color to;
    if (pattern == CheckerboardPattern.lightToDark) {
      from = Colors.white;
      to = Colors.black;
    } else {
      from = Colors.black;
      to = Colors.white;
    }
    const waveLength = .3;
    const firstWave = .2;
    const secondWave = .5;
    final boxesGrid = BoxesGrid.forDimensions(dimensions);
    final List<AnimatedCheckerBox> boxes = [];
    for (int x = 0; x < boxesGrid.columns; x++) {
      for (int y = 0; y < boxesGrid.rows; y++) {
        final waveOffset = (x + y) % 2 == 0 ? firstWave : secondWave;
        final nth = (x * boxesGrid.columns) + (y * boxesGrid.rows);
        final double checkerOffset = nth == 0 ? 0 : waveLength / nth;
        final begin = waveOffset + checkerOffset;
        late final double end;
        if (kDebugMode) {
          final calculated = begin + .2;
          if (calculated > 1) {
            print('ERROR');
          }
          end = min(1, calculated);
        } else {
          end = begin + .2;
        }
        boxes.add(AnimatedCheckerBox(
          top: boxesGrid.boxSize.height * y,
          left: boxesGrid.boxSize.width * x,
          size: boxesGrid.boxSize,
          intervalBegin: begin,
          intervalEnd: end,
          colorFrom: from,
          colorTo: to,
        ));
      }
    }
    return boxes;
  }
}

class _AnimatedCheckerboardState extends State<AnimatedCheckerboard> {
  late final Timer backgroundTimer;
  late final Timer completionTimer;

  @override
  void initState() {
    super.initState();
    backgroundTimer = Timer(const Duration(milliseconds: 1), changeBackground);
    completionTimer = Timer(const Duration(milliseconds: durationMS), finish);
  }

  void changeBackground() {
    if (widget.pattern == CheckerboardPattern.lightToDark) {
      TodaiBackground.of(context).dark();
    } else {
      TodaiBackground.of(context).light();
    }
  }

  void finish() {
    widget.onFinished();
  }

  @override
  void dispose() {
    backgroundTimer.cancel();
    completionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.dimensions.devicePadding.top),
      child: Stack(children: widget.boxes),
    );
  }
}

class AnimatedCheckerBox extends StatefulWidget {
  final double top;
  final double left;
  final double intervalBegin;
  final double intervalEnd;
  final Size size;
  final Color colorFrom;
  final Color colorTo;

  const AnimatedCheckerBox(
      {super.key,
      required this.top,
      required this.left,
      required this.size,
      required this.intervalBegin,
      required this.intervalEnd,
      required this.colorFrom,
      required this.colorTo});

  @override
  State<StatefulWidget> createState() => AnimatedCheckerBoxState();
}

class AnimatedCheckerBoxState extends State<AnimatedCheckerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: durationMS));

    _color = ColorTween(begin: widget.colorFrom, end: widget.colorTo).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(widget.intervalBegin, widget.intervalEnd,
            curve: Curves.ease),
      ),
    );

    _controller.animateTo(1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
              width: widget.size.width,
              height: widget.size.height,
              color: _color.value);
        },
      ),
    );
  }
}
