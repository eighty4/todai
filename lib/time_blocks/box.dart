import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/data.dart';
import 'package:todai/time_blocks/input.dart';
import 'package:todai/time_blocks/swipe.dart';

class TimeBlockBox extends StatefulWidget {
  static const double marginHeight = 20;
  static const double minimizedHeight = 20;
  static const TextStyle placeholderTextStyle = TextStyle(
      fontSize: 22,
      color: Color.fromARGB(204, 255, 255, 255),
      fontStyle: FontStyle.italic);
  static const TextStyle textStyle =
      TextStyle(fontSize: 26, color: Color.fromARGB(255, 255, 255, 255));

  final TodaiDimensions dimensions;
  final VoidCallback onEditBlur;
  final TimeBlockEditCallback onEditChange;
  final TimeBlockCallback onEditFocus;
  final TimeBlockCallback onSwipedComplete;
  final TimeBlock timeBlock;
  final TimeBlockUiState uiState;

  const TimeBlockBox(
      {Key? key,
      required this.dimensions,
      required this.timeBlock,
      required this.onEditBlur,
      required this.onEditChange,
      required this.onEditFocus,
      required this.onSwipedComplete,
      required this.uiState})
      : super(key: key);

  @override
  State<TimeBlockBox> createState() => _TimeBlockBoxState();
}

class _TimeBlockBoxState extends State<TimeBlockBox>
    with TickerProviderStateMixin {
  late final AnimationController _editingC;
  CompletionSwiping? swiping;

  late Animation<Color?> _color;
  late Animation<double> _height;
  late Animation<double> _top;

  @override
  void initState() {
    super.initState();
    _editingC = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _handleTimeBlockState();
    _initHeightAnimation();
    _initTopPosAnimation();
    _color = ColorTween(begin: Colors.black, end: Colors.white).animate(
      CurvedAnimation(
        parent: _editingC,
        curve: const Interval(.4, .6, curve: Curves.ease),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TimeBlockBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uiState != oldWidget.uiState) {
      _handleTimeBlockState();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _editingC.dispose();
  }

  _handleTimeBlockState() {
    if (hasEditFocus()) {
      _initTopPosAnimation();
      _initHeightAnimation();
      _editingC.animateTo(1);
    } else if (inEditBlur()) {
      _initTopPosAnimation();
      _initHeightAnimation();
      _editingC.animateTo(1);
    } else {
      _editingC.animateTo(0);
    }
  }

  bool inDisplayMode() => widget.uiState.editing == null;

  bool inEditBlur() => widget.uiState.editing != null && !hasEditFocus();

  bool hasEditFocus() => widget.uiState.editing == widget.timeBlock.index;

  _initTopPosAnimation() {
    final double openTopPos = widget.dimensions.spaceAboveBlocks +
        ((widget.dimensions.blockHeight + TimeBlockBox.marginHeight) *
            widget.timeBlock.index);
    late final double editTopPos;
    if (widget.uiState.editing == null) {
      editTopPos = 0;
    } else if (widget.timeBlock.index <= widget.uiState.editing!) {
      editTopPos = widget.dimensions.spaceAboveBlocksEditing +
          ((TimeBlockBox.minimizedHeight + TimeBlockBox.marginHeight) *
              widget.timeBlock.index);
    } else {
      editTopPos = widget.dimensions.spaceAboveBlocksEditing +
          widget.dimensions.blockHeight +
          (TimeBlockBox.minimizedHeight * (widget.timeBlock.index - 1)) +
          (TimeBlockBox.marginHeight * widget.timeBlock.index);
    }
    final double intervalStart = .1 * widget.timeBlock.index;
    final double intervalEnd = intervalStart + .6;
    _top = Tween<double>(begin: openTopPos, end: editTopPos).animate(
      CurvedAnimation(
        parent: _editingC,
        curve: Interval(intervalStart, intervalEnd, curve: Curves.ease),
      ),
    );
  }

  _initHeightAnimation() {
    final double intervalStart = .1 * widget.timeBlock.index;
    final double intervalEnd = intervalStart + .6;
    final editHeight = hasEditFocus()
        ? widget.dimensions.blockHeight
        : TimeBlockBox.minimizedHeight;
    _height =
        Tween<double>(begin: widget.dimensions.blockHeight, end: editHeight)
            .animate(
      CurvedAnimation(
        parent: _editingC,
        curve: Interval(intervalStart, intervalEnd, curve: Curves.ease),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
            animation: _editingC,
            builder: _buildAnimation,
            child: _buildWidget()),
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
        ));
  }

  Widget _buildWidget() {
    if (hasEditFocus()) {
      return TimeBlockInput(
          dimensions: widget.dimensions,
          onBlur: widget.onEditBlur,
          onEdit: widget.onEditChange,
          timeBlock: widget.timeBlock);
    }
    Widget box = Container(
      color: Colors.transparent,
      child: Center(
          child: Text(
        widget.timeBlock.text,
        style: widget.timeBlock.placeholder
            ? TimeBlockBox.placeholderTextStyle
            : TimeBlockBox.textStyle,
      )),
    );
    if (inDisplayMode()) {
      if (widget.timeBlock.placeholder) {
        box = GestureDetector(onTap: onEdit, child: box);
      } else {
        box = GestureDetector(
          onTap: onEdit,
          onHorizontalDragStart: onSwipeStart,
          onHorizontalDragUpdate: onSwipeUpdate,
          onHorizontalDragEnd: onSwipeEnd,
          child: CustomPaint(
              foregroundPainter: CompletionLinePainter(swiping: swiping),
              size: Size(widget.dimensions.screenSize.width,
                  widget.dimensions.blockHeight),
              child: box),
        );
      }
    }
    return box;
  }

  void onEdit() => widget.onEditFocus(widget.timeBlock.index);

  void onSwipeStart(DragStartDetails details) {
    assert(swiping == null || swiping!.done);
    setState(() => swiping = CompletionSwiping.start(details.localPosition.dx));
  }

  void onSwipeUpdate(DragUpdateDetails details) {
    setState(() => swiping = swiping?.ongoing(details.delta.dx));
  }

  void onSwipeEnd(DragEndDetails details) {
    assert(swiping != null);
    final completed =
        swiping!.distance > widget.dimensions.screenSize.width * .3;
    final swiped =
        completed ? swiping!.end(details.primaryVelocity ?? 0) : null;
    setState(() => swiping = swiped);
    if (completed) {
      widget.onSwipedComplete(widget.timeBlock.index);
    }
  }
}
