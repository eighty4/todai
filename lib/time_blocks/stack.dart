import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'box.dart';
import 'controller.dart';
import 'count.dart';
import 'stripe.dart';

class TimeBlockStack extends StatefulWidget {
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
  late final TheTimeBlockController _controller;
  late final AnimationController _editingAnimationController;
  late final StreamSubscription<TimeBlockEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _controller = TheTimeBlockController(widget.blockCount);
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
          // ...visualGuide(),
          ...List.generate(widget.blockCount.toInt(), (index) {
            return TimeBlockBox(
                dimensions: widget.dimensions,
                timeBlock: _controller.timeBlock(index),
                onBlur: blurEditing,
                onEdit: focusEditing,
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
