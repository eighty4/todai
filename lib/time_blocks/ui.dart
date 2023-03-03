import 'package:flutter/material.dart';
import '../day.dart';
import '../dimensions.dart';
import 'count.dart';
import 'stack.dart';

class TimeBlocksUi extends StatelessWidget {
  final TodaiDimensions dimensions;
  final TimeBlockCount blockCount;

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
          child: TimeBlockStack(
              blockCount: TimeBlockCount.four,
              dimensions: dimensions,
              editingStripes: const [],
              onEditing: (b) {}),
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
