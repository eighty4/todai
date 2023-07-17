import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/data.dart';

typedef TimeBlockCallback = void Function(int);

class TimeBlockBox extends StatefulWidget {
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

  final TodaiDimensions dimensions;
  final TimeBlock timeBlock;
  final VoidCallback onBlur;
  final TimeBlockCallback onEdit;
  final TimeBlockState state;

  const TimeBlockBox(
      {Key? key,
      required this.dimensions,
      required this.timeBlock,
      required this.onBlur,
      required this.onEdit,
      required this.state})
      : super(key: key);

  @override
  State<TimeBlockBox> createState() => _TimeBlockBoxState();
}

enum TimeBlockBoxDisplayMode { display, hidden, editFocus, editBlur }

class _TimeBlockBoxState extends State<TimeBlockBox>
    with TickerProviderStateMixin {
  late final AnimationController _editingC;
  late final AnimationController _displayC;
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
    if (widget.state != oldWidget.state) {
      _handleTimeBlockState();
    }
  }

  _handleTimeBlockState() {
    if (widget.state.editing == widget.timeBlock.index) {
      setState(() => mode = TimeBlockBoxDisplayMode.editFocus);
      _initTopPosAnimation();
      _initHeightAnimation();
      _editingC.animateTo(1);
    } else if (widget.state.editing != null) {
      setState(() => mode = TimeBlockBoxDisplayMode.editBlur);
      _initTopPosAnimation();
      _initHeightAnimation();
      _editingC.animateTo(1);
    } else {
      setState(() => mode = TimeBlockBoxDisplayMode.display);
      _editingC.animateTo(0);
    }
  }

  _initTopPosAnimation() {
    final double openTopPos = widget.dimensions.spaceAboveBlocks +
        ((widget.dimensions.blockHeight + TimeBlockBox.marginHeight) *
            widget.timeBlock.index);
    late final double editTopPos;
    if (widget.state.editing == null) {
      editTopPos = 0;
    } else if (widget.timeBlock.index <= widget.state.editing!) {
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
    final editHeight = mode == TimeBlockBoxDisplayMode.editFocus
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
  void dispose() {
    super.dispose();
    _editingC.dispose();
    _displayC.dispose();
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
