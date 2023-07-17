import 'package:flutter/material.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/box.dart';
import 'package:todai/time_blocks/controller.dart';
import 'package:todai/time_blocks/count.dart';
import 'package:todai/time_blocks/stripe.dart';

class TimeBlockStack extends StatefulWidget {
  final TimeBlockCount blockCount;
  final TodaiDimensions dimensions;

  const TimeBlockStack(
      {Key? key, required this.blockCount, required this.dimensions})
      : super(key: key);

  @override
  State<TimeBlockStack> createState() => _TimeBlockStackState();
}

class _TimeBlockStackState extends State<TimeBlockStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _editingAnimationController;
  late final List<TimeBlock> data;
  TimeBlockState state = TimeBlockState.reset;

  @override
  void initState() {
    super.initState();
    data = getRandomTimeBlocks(widget.blockCount.toInt());
    _editingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    super.dispose();
    _editingAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: blurEditing,
      child: Container(
        color: Colors.transparent,
        child: Stack(children: [
          // ...visualGuide(),
          ...List.generate(widget.blockCount.toInt(), (index) {
            return TimeBlockBox(
                dimensions: widget.dimensions,
                timeBlock: data[index],
                onBlur: blurEditing,
                onEdit: focusEditing,
                state: state);
          }),
          AnimatedEditingStripes(dimensions: widget.dimensions, state: state),
        ]),
      ),
    );
  }

  void focusEditing(int index) {
    updateState(TimeBlockState.editing(index));
  }

  void blurEditing() {
    updateState(TimeBlockState.reset);
  }

  void updateState(TimeBlockState state) {
    setState(() {
      this.state = state;
    });
    final editing = state.editing == null;
    if (editing) {
      TodaiBackground.of(context).light();
    } else {
      TodaiBackground.of(context).dark();
    }
    _editingAnimationController.animateTo(editing ? 0 : 1);
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
