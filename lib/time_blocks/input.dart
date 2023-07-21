import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/data.dart';

class TimeBlockInput extends StatefulWidget {
  static const TextStyle invertTextStyle =
      TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0));
  final TodaiDimensions dimensions;
  final VoidCallback onBlur;
  final TimeBlockEditCallback onEdit;
  final TimeBlock timeBlock;

  const TimeBlockInput(
      {super.key,
      required this.dimensions,
      required this.onBlur,
      required this.onEdit,
      required this.timeBlock});

  @override
  State<TimeBlockInput> createState() => _TimeBlockInputState();
}

class _TimeBlockInputState extends State<TimeBlockInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _prompt;
  bool closeHandled = false;

  @override
  void initState() {
    super.initState();
    if (!widget.timeBlock.placeholder) {
      _controller.text = widget.timeBlock.text;
      if (widget.timeBlock.completed) {
        _controller.selection = TextSelection(
            baseOffset: 0, extentOffset: widget.timeBlock.text.length);
      }
    }
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        close();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_prompt != null)
          Positioned(
              top: 4,
              left: 8,
              child: Text(_prompt!,
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic))),
        if (_prompt != null)
          Container(
            height: widget.dimensions.blockHeight,
            width: widget.dimensions.screenSize.width,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.pink, width: 10))),
          ),
        SizedBox(
          height: widget.dimensions.blockHeight,
          child: Center(
            child: buildTextField(),
          ),
        )
      ],
    );
  }

  TextField buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(border: InputBorder.none),
      style: TimeBlockInput.invertTextStyle,
      onEditingComplete: close,
      onTapOutside: (PointerDownEvent e) => close(),
    );
  }

  String get _value => _controller.value.text.trim();

  void close() {
    if (closeHandled) {
      return;
    }
    if (!validate()) {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
      return;
    }
    closeHandled = true;
    FocusScope.of(context).unfocus();
    widget.onBlur();
    final todo = _value;
    if (widget.timeBlock.text != todo) {
      widget.onEdit(widget.timeBlock.index, todo);
    }
  }

  bool validate() {
    if (_value.split(' ').length > 2) {
      setState(() => _prompt = "Todos can only use two words");
      return false;
    } else if (_prompt != null) {
      setState(() => _prompt = null);
    }
    return true;
  }
}
