import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'day.dart';
import 'dimensions.dart';

enum BoomerangDirection { up, right, down, left }

extension on BoomerangDirection {
  int quarterTurns() {
    switch (this) {
      case BoomerangDirection.up:
        return 1;
      case BoomerangDirection.right:
        return 2;
      case BoomerangDirection.down:
        return 3;
      case BoomerangDirection.left:
        return 4;
    }
  }
}

class BoomerangSvgPicture extends StatelessWidget {
  final BoomerangDirection direction;
  final double height;
  final double width;

  const BoomerangSvgPicture(
      {super.key,
      required this.direction,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: direction.quarterTurns(),
      child: SvgPicture.asset("assets/boomerang.svg",
          height: height,
          width: width,
          alignment: Alignment.center,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          fit: BoxFit.contain),
    );
  }
}

class Boomerang extends StatelessWidget {
  static const double svgWidth = 35;
  static const double svgHeight = 70;
  static const double halfSvgWidth = svgWidth / 2;
  static const double halfSvgHeight = svgHeight / 2;

  final Day day;
  final TodaiDimensions dimensions;
  final VoidCallback onTap;

  const Boomerang(
      {super.key,
      required this.day,
      required this.dimensions,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final positionedFromTop = (dimensions.screenSize.height / 2) -
        halfSvgHeight +
        (dimensions.blockHeight / 4);
    final positionedFromEdge = dimensions.gutterWidth / 2 - halfSvgWidth;
    final svg = GestureDetector(
      onTap: onTap,
      child: BoomerangSvgPicture(
          direction: day == Day.today
              ? BoomerangDirection.left
              : BoomerangDirection.right,
          height: svgHeight,
          width: svgWidth),
    );
    switch (day) {
      case Day.today:
        return Positioned(
          top: positionedFromTop,
          right: positionedFromEdge,
          child: svg,
        );
      case Day.tomorrow:
        return Positioned(
          top: positionedFromTop,
          left: positionedFromEdge,
          child: svg,
        );
    }
  }
}
