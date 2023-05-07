import 'dart:async';
import 'package:flutter/material.dart';
import 'controller.dart';

typedef TimeBlockCallback = void Function(int);

class TimeBlockBox extends StatefulWidget {
  static const double blockHeight = 80;
  static const double marginHeight = 20;
  static const double minimizedHeight = 20;
  static const TextStyle placeholderTextStyle = TextStyle(
      fontSize: 22,
      color: Color.fromARGB(204, 255, 255, 255),
      fontStyle: FontStyle.italic);
  static const TextStyle textStyle =
      TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255));
  static const TextStyle invertTextStyle =
      TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0));

  final TimeBlock timeBlock;
  final VoidCallback onBlur;
  final TimeBlockCallback onEdit;
  final Stream<TimeBlockEvent> stream;
  final double spaceAbove;
  final double spaceAboveEditing;

  const TimeBlockBox(
      {Key? key,
      required this.timeBlock,
      required this.onBlur,
      required this.onEdit,
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
    if (event.editing == widget.timeBlock.index) {
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
        ((TimeBlockBox.blockHeight + TimeBlockBox.marginHeight) *
            widget.timeBlock.index);
    late final double end;
    if (event.editing == null) {
      end = 0;
    } else if (widget.timeBlock.index <= event.editing!) {
      end = widget.spaceAboveEditing +
          ((TimeBlockBox.minimizedHeight + TimeBlockBox.marginHeight) *
              widget.timeBlock.index);
    } else {
      end = widget.spaceAboveEditing +
          TimeBlockBox.blockHeight +
          (TimeBlockBox.minimizedHeight * (widget.timeBlock.index - 1)) +
          (TimeBlockBox.marginHeight * widget.timeBlock.index);
    }
    final double iStart = .1 * widget.timeBlock.index;
    final double iEnd = iStart + .6;
    _top = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _editingC,
        curve: Interval(iStart, iEnd, curve: Curves.ease),
      ),
    );
  }

  _initHeightAnimation(TimeBlockEvent event) {
    final double index = widget.timeBlock.index.toDouble();
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
      box = Container(
        color: Colors.transparent,
        child: Center(
            child: Text(
          widget.timeBlock.text,
          style: widget.timeBlock.placeholder
              ? TimeBlockBox.placeholderTextStyle
              : TimeBlockBox.textStyle,
        )),
      );
    } else {
      box = Center(
        child: TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: InputBorder.none),
          style: TimeBlockBox.invertTextStyle,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          onSubmitted: onSubmit,
          onTapOutside: (PointerDownEvent e) {
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }
    final VoidCallback? onTap =
        mode == TimeBlockBoxDisplayMode.display ? onEdit : null;
    return Stack(
      children: [
        AnimatedBuilder(
            animation: _editingC,
            builder: _buildAnimation,
            child: GestureDetector(onTap: onTap, child: box))
      ],
    );
  }

  void onSubmit(String s) {
    widget.onBlur();
  }

  void onEdit() {
    widget.onEdit(widget.timeBlock.index);
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
