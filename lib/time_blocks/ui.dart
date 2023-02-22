import 'package:flutter/material.dart';
import 'package:todai/day.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/count.dart';
import 'group.dart';

class TimeBlocksUi extends StatelessWidget {
  final TodaiDimensions dimensions;
  final BlockCount blockCount;

  const TimeBlocksUi(
      {Key? key, required this.blockCount, required this.dimensions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          top: 0,
          left: calcPositionFromLeft(Day.today),
          right: calcPositionFromRight(Day.today),
          child: TimeBlockGroup(
              blockCount: blockCount, day: Day.today, dimensions: dimensions),
          // Boomerang(
          //     day: day,
          //     dimensions: widget.dimensions,
          //     onTap: () => setState(() => day = day.other())),
        )
      ],
    );
  }

  double calcPositionFromRight(Day day) {
    return day == Day.today ? dimensions.gutterWidth : dimensions.edgePadding;
  }

  double calcPositionFromLeft(Day day) {
    return day == Day.today ? dimensions.edgePadding : dimensions.gutterWidth;
  }
}
