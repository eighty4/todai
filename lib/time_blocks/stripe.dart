import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/box.dart';
import 'package:todai/time_blocks/controller.dart';

class AnimatedEditingStripes extends StatefulWidget {
  final TodaiDimensions dimensions;
  final Stream<TimeBlockEvent> stream;

  const AnimatedEditingStripes(
      {super.key, required this.dimensions, required this.stream});

  @override
  State<AnimatedEditingStripes> createState() => _AnimatedEditingStripesState();
}

class _AnimatedEditingStripesState extends State<AnimatedEditingStripes>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final StreamSubscription<TimeBlockEvent> _subscription;
  final Map<double, Animation<double>> _stripes = HashMap();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    const intervalStart = .2;
    const intervalStep = .075;
    const intervalEnd = .5;
    intervalFn(int i) => Interval(min(1, intervalStart + (i * intervalStep)),
        min(1, intervalEnd + (i * intervalStep)),
        curve: Curves.easeInOutQuad);
    final above = (widget.dimensions.spaceAboveBlocksEditing / 40).floor();
    for (int i = 1; i <= above; i++) {
      final top = widget.dimensions.spaceAboveBlocksEditing - i * 40;
      final animation =
          Tween<double>(begin: widget.dimensions.windowSize.width, end: 0)
              .animate(
        CurvedAnimation(
          parent: _controller,
          curve: intervalFn(i),
        ),
      );
      _stripes[top] = animation;
    }
    final spaceBelowOffset = (TimeBlockBox.marginHeight * 3) +
        (TimeBlockBox.minimizedHeight * 3) +
        widget.dimensions.spaceAboveBlocksEditing +
        widget.dimensions.blockHeight;
    final below =
        ((widget.dimensions.screenSize.height - spaceBelowOffset) / 40).floor();
    for (int i = 1; i <= below; i++) {
      final top = spaceBelowOffset + (i * 40) - 20;
      final animation =
          Tween<double>(begin: widget.dimensions.windowSize.width, end: 0)
              .animate(
        CurvedAnimation(
          parent: _controller,
          curve: intervalFn(i),
        ),
      );
      _stripes[top] = animation;
    }
    _subscription = widget.stream.listen((event) {
      if (event.editing == null) {
        _controller.reset();
      } else {
        _controller.animateTo(1);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel().then((value) => _controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _stripes.entries.map((e) {
        return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _stripes[e.key]!.value,
                top: e.key,
                child: Container(
                    height: TimeBlockBox.minimizedHeight,
                    width: widget.dimensions.windowSize.width,
                    color: Colors.white),
              );
            });
      }).toList(),
    );
  }
}
