import 'dart:async';
import 'package:flutter/material.dart';
import '../dimensions.dart';
import 'box.dart';
import 'count.dart';
import 'event.dart';
import 'stripe.dart';

class TimeBlockStack extends StatefulWidget {
  static const double blocksHeight =
      (TimeBlockBox.blockHeight * 4) + (TimeBlockBox.marginHeight * 3);
  static const double blocksHeightEditing = TimeBlockBox.blockHeight +
      (TimeBlockBox.marginHeight * 3) +
      (TimeBlockBox.minimizedHeight * 3);
  final TimeBlockCount blockCount;
  final TodaiDimensions dimensions;
  final List<AnimatedEditingStripe> editingStripes;

  // todo remove callback coupling ColorInversion and TimeBlockStack
  final void Function(bool) onEditing;

  const TimeBlockStack(
      {Key? key,
      required this.blockCount,
      required this.dimensions,
      required this.editingStripes,
      required this.onEditing})
      : super(key: key);

  @override
  State<TimeBlockStack> createState() => _TimeBlockStackState();
}

class _TimeBlockStackState extends State<TimeBlockStack>
    with SingleTickerProviderStateMixin {
  final StreamController<TimeBlockEvent> _controller =
      StreamController.broadcast();
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
      onTap: () {
        closeEditing();
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(children: [
          ...List.generate(widget.blockCount.toInt(), (index) {
            return TimeBlockBox(
                index: index,
                spaceAbove: widget.dimensions.spaceAboveBlocks,
                spaceAboveEditing: widget.dimensions.spaceAboveBlocksEditing,
                stream: _controller.stream);
          }),
          ...widget.editingStripes,
          buildMenu(),
        ]),
      ),
    );
  }

  Positioned buildMenu() {
    return Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.blockCount.toInt() + 1, (index) {
            return SizedBox(
              width: 50,
              height: 50,
              child: OutlinedButton(
                  child: Text(index == widget.blockCount.toInt()
                      ? 'X'
                      : (index + 1).toString()),
                  onLongPress: () => dispatch(index, longPress: true),
                  onPressed: () => dispatch(index, longPress: false)),
            );
          }),
        ));
  }

  void dispatch(int index, {required bool longPress}) {
    if (index == widget.blockCount.toInt()) {
      closeEditing();
    } else {
      startEditing(index);
    }
  }

  void startEditing(int index) {
    _controller.add(TimeBlockEvent(display: true, editing: index));
  }

  void closeEditing() {
    _controller.add(TimeBlockEvent.initialState);
  }

  List<AnimatedEditingStripe> buildAnimatedEditingStripes() {
    List<AnimatedEditingStripe> stripes = [];
    final spaceBelowEditing = widget.dimensions.screenSize.height -
        TimeBlockStack.blocksHeightEditing -
        widget.dimensions.spaceAboveBlocksEditing;
    int stripesBelow = (spaceBelowEditing /
            (TimeBlockBox.marginHeight + TimeBlockBox.minimizedHeight))
        .floor();
    for (int i = 0; i < stripesBelow; i++) {
      // stripes.add(AnimatedEditingStripe(
      //     interval: const Interval(.6, .7, curve: Curves.ease),
      //     top: 500,
      //     width: size.width));
    }
    return stripes;
  }
}
