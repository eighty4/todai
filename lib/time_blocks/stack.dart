import 'dart:async';
import 'package:flutter/material.dart';
import '../dimensions.dart';
import 'box.dart';
import 'controller.dart';
import 'count.dart';
import 'stripe.dart';

class TimeBlockStack extends StatefulWidget {
  static const double blocksHeight =
      (TimeBlockBox.blockHeight * 4) + (TimeBlockBox.marginHeight * 3);
  static const double blocksHeightEditing = TimeBlockBox.blockHeight +
      (TimeBlockBox.marginHeight * 3) +
      (TimeBlockBox.minimizedHeight * 3);
  final TimeBlockCount blockCount;
  final TodaiDimensions dimensions;

  // todo remove callback coupling ColorInversion and TimeBlockStack
  final void Function(bool) onEditing;

  const TimeBlockStack(
      {Key? key,
      required this.blockCount,
      required this.dimensions,
      required this.onEditing})
      : super(key: key);

  @override
  State<TimeBlockStack> createState() => _TimeBlockStackState();
}

class _TimeBlockStackState extends State<TimeBlockStack>
    with SingleTickerProviderStateMixin {
  final TheTimeBlockController _controller = TheTimeBlockController();
  late final AnimationController _editingAnimationController;
  late final StreamSubscription<TimeBlockEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _editingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _subscription = _controller.stream.listen((event) {
      final editing = event.editing == null;
      if (event.display) {
        widget.onEditing(editing);
      }
      _editingAnimationController.animateTo(editing ? 0 : 1);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingAnimationController.dispose();
    _subscription.cancel().then((v) => _controller.close());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: blurEditing,
      child: Container(
        color: Colors.transparent,
        child: Stack(children: [
          ...List.generate(widget.blockCount.toInt(), (index) {
            return TimeBlockBox(
                timeBlock: _controller.timeBlock(index),
                onBlur: blurEditing,
                onEdit: focusEditing,
                spaceAbove: widget.dimensions.spaceAboveBlocks,
                spaceAboveEditing: widget.dimensions.spaceAboveBlocksEditing,
                stream: _controller.stream);
          }),
          AnimatedEditingStripes(
              dimensions: widget.dimensions, stream: _controller.stream),
        ]),
      ),
    );
  }

  void focusEditing(int index) {
    _controller.focusEditing(index);
  }

  void blurEditing() {
    _controller.blurEditing();
  }
}
