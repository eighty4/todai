import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/boxes.dart';

const durationMS = 6000;

class IntroStep1 extends StatefulWidget {
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  const IntroStep1(
      {super.key, required this.dimensions, required this.onFinished});

  @override
  State<IntroStep1> createState() => _IntroStep1State();
}

class _IntroStep1State extends State<IntroStep1> {
  late final List<AnimatedCheckerBox> boxes;

  @override
  void initState() {
    super.initState();
    boxes = calculateAnimationWithBug(widget.dimensions);
    Future.delayed(Duration(milliseconds: (durationMS / 2).floor()), () {
      TodaiBackground.of(context).dark();
    });
    Future.delayed(const Duration(milliseconds: durationMS), () {
      widget.onFinished();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.dimensions.devicePadding.top),
      child: Stack(children: boxes),
    );
  }
}

List<AnimatedCheckerBox> calculateAnimationWithBug(TodaiDimensions dimensions) {
  final boxesGrid = BoxesGrid.forDimensions(dimensions);
  final List<AnimatedCheckerBox> boxes = [];
  for (int x = 0; x < boxesGrid.columns; x++) {
    for (int y = 0; y < boxesGrid.rows; y++) {
      final waveBegin = (x + y) % 2 == 0 ? .2 : .5;
      const waveLength = .3;
      final nth = (y * boxesGrid.columns) + x;
      late final double offset;
      if (nth == 0) {
        offset = 0;
      } else {
        offset = waveLength / nth;
      }
      final begin = waveBegin + offset;
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
          begin: begin,
          end: end));
    }
  }
  return boxes;
}

class Point {
  static const Point zeroed = Point(0, 0);
  final int x;
  final int y;

  const Point(this.x, this.y);
}

class Line {
  final Point from;
  final Point to;

  const Line(this.from, this.to);

  double distance() {
    final xDiff = from.x - to.x;
    final yDiff = from.y - to.y;
    return sqrt((xDiff * xDiff) + (yDiff * yDiff));
  }
}

class AnimationPath {
  Point marker = Point.zeroed;
  double distance = 0;
  final List<Line> lines = [];

  /// size of coordinate space
  final Size size;

  AnimationPath(this.size);

  void moveTo(int x, int y) {
    marker = Point(x, y);
  }

  void lineTo(int x, int y) {
    final to = Point(x, y);
    final line = Line(marker, to);
    lines.add(line);
    marker = to;
    distance += line.distance();
  }
}

class AnimatedCheckerBox extends StatefulWidget {
  final double top;
  final double left;
  final double begin;
  final double end;
  final Size size;

  const AnimatedCheckerBox(
      {super.key,
      required this.top,
      required this.left,
      required this.size,
      required this.begin,
      required this.end});

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

    _color = ColorTween(begin: Colors.white, end: Colors.black).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(widget.begin, widget.end, curve: Curves.ease),
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
