import 'dart:async';
import 'package:flutter/material.dart';
import 'event.dart';

class TimeBlockBox extends StatefulWidget {
  static const double blockHeight = 80;
  static const double marginHeight = 20;
  static const double minimizedHeight = 20;
  final int index;
  final Stream<TimeBlockEvent> stream;
  final double spaceAbove;
  final double spaceAboveEditing;

  const TimeBlockBox(
      {Key? key,
      required this.index,
      required this.stream,
      required this.spaceAbove,
      required this.spaceAboveEditing})
      : super(key: key);

  @override
  State<TimeBlockBox> createState() => _TimeBlockBoxState();
}

enum TimeBlockBoxDisplayMode { display, hidden, editFocus, editBlur }

class _TimeBlockBoxState extends State<TimeBlockBox>
    with TickerProviderStateMixin {
  late AnimationController _editingC;
  late AnimationController _displayC;
  late StreamSubscription<TimeBlockEvent> _subscription;
  TimeBlockBoxDisplayMode mode = TimeBlockBoxDisplayMode.display;

  late Animation<Color?> _color;
  late Animation<double> _height;
  late Animation<double> _top;

  @override
  void initState() {
    super.initState();
    _editingC = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _displayC = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _subscription = widget.stream.listen(_handleEvent);
    _initHeightAnimation(TimeBlockEvent.initialState);
    _initTopAnimation(TimeBlockEvent.initialState);
    _color = ColorTween(begin: Colors.black, end: Colors.white).animate(
      CurvedAnimation(
        parent: _editingC,
        curve: const Interval(.4, .6, curve: Curves.ease),
      ),
    );
  }

  _handleEvent(TimeBlockEvent event) {
    if (event.editing == widget.index) {
      setState(() => mode = TimeBlockBoxDisplayMode.editFocus);
      _initTopAnimation(event);
      _initHeightAnimation(event);
      _editingC.animateTo(1);
    } else if (event.editing != null) {
      setState(() => mode = TimeBlockBoxDisplayMode.editBlur);
      _initTopAnimation(event);
      _initHeightAnimation(event);
      _editingC.animateTo(1);
    } else {
      setState(() => mode = TimeBlockBoxDisplayMode.display);
      _editingC.animateTo(0);
    }
  }

  _initTopAnimation(TimeBlockEvent event) {
    final double begin = widget.spaceAbove +
        ((TimeBlockBox.blockHeight + TimeBlockBox.marginHeight) * widget.index);
    late final double end;
    if (event.editing == null) {
      end = 0;
    } else if (widget.index <= event.editing!) {
      end = widget.spaceAboveEditing +
          ((TimeBlockBox.minimizedHeight + TimeBlockBox.marginHeight) *
              widget.index);
    } else {
      end = widget.spaceAboveEditing +
          TimeBlockBox.blockHeight +
          (TimeBlockBox.minimizedHeight * (widget.index - 1)) +
          (TimeBlockBox.marginHeight * widget.index);
    }
    final double iStart = .1 * widget.index;
    final double iEnd = iStart + .6;
    _top = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _editingC,
        curve: Interval(iStart, iEnd, curve: Curves.ease),
      ),
    );
  }

  _initHeightAnimation(TimeBlockEvent event) {
    final double index = widget.index.toDouble();
    final double iStart = .1 * index;
    final double iEnd = iStart + .6;
    final end = mode == TimeBlockBoxDisplayMode.editFocus
        ? TimeBlockBox.blockHeight
        : TimeBlockBox.minimizedHeight;
    _height = Tween<double>(begin: TimeBlockBox.blockHeight, end: end).animate(
      CurvedAnimation(
        parent: _editingC,
        curve: Interval(iStart, iEnd, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _editingC.dispose();
    _displayC.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget box;
    if (mode != TimeBlockBoxDisplayMode.editFocus) {
      box = Container(color: Colors.transparent);
    } else {
      box = Center(
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(
              fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onTapOutside: (PointerDownEvent e) {
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }
    return Stack(
      children: [
        AnimatedBuilder(
            animation: _editingC, builder: _buildAnimation, child: box)
      ],
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Positioned(
      top: _top.value,
      child: Container(
        color: _color.value,
        height: _height.value,
        width: MediaQuery.of(context).size.width,
        child: Opacity(
          opacity: 1,
          child: child,
        ),
      ),
    );
  }
}
