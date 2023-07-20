import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/box.dart';
import 'package:todai/time_blocks/count.dart';
import 'package:todai/time_blocks/data.dart';
import 'package:todai/time_blocks/stripe.dart';

class TimeBlockStack extends StatefulWidget {
  final TimeBlockCount blockCount;
  final TodaiDimensions dimensions;
  final TimeBlockCallback onComplete;
  final TimeBlockEditCallback onEdit;
  final List<TimeBlock> todos;

  const TimeBlockStack(
      {Key? key,
      required this.blockCount,
      required this.dimensions,
      required this.onComplete,
      required this.onEdit,
      required this.todos})
      : super(key: key);

  @override
  State<TimeBlockStack> createState() => _TimeBlockStackState();
}

class _TimeBlockStackState extends State<TimeBlockStack>
    with SingleTickerProviderStateMixin {
  TimeBlockUiState uiState = TimeBlockUiState.reset;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(children: [
        // ...visualGuide(),
        ...List.generate(widget.blockCount.toInt(), (index) {
          return TimeBlockBox(
              dimensions: widget.dimensions,
              timeBlock: widget.todos[index],
              onEditBlur: _blurEditing,
              onEditChange: widget.onEdit,
              onEditFocus: _focusEditing,
              onSwipedComplete: widget.onComplete,
              uiState: uiState);
        }),
        AnimatedEditingStripes(
            dimensions: widget.dimensions, editing: uiState.isEditingActive()),
      ]),
    );
  }

  void _focusEditing(int index) {
    _updateUiStatus(TimeBlockUiState.editing(index));
  }

  void _blurEditing() {
    _updateUiStatus(TimeBlockUiState.reset);
  }

  void _updateUiStatus(TimeBlockUiState uiState) {
    setState(() {
      this.uiState = uiState;
    });
    if (uiState.isEditingActive()) {
      TodaiBackground.of(context).dark();
    } else {
      TodaiBackground.of(context).light();
    }
  }

  List<Widget> visualGuide() {
    const even = Colors.red;
    const odd = Colors.pink;
    const height = 50.0;
    final count = (widget.dimensions.screenSize.height / height / 2).floor();
    return [
      ...(List.generate(
          count,
          (index) => Positioned(
              top: index * height,
              left: 0,
              right: 0,
              child: Container(
                  color: index % 2 == 0 ? even : odd, height: height)))),
      ...(List.generate(
          count,
          (index) => Positioned(
              bottom: index * height,
              left: 0,
              right: 0,
              child: Container(
                  color: index % 2 == 0 ? even : odd, height: height)))),
    ];
  }
}
