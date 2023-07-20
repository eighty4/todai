import 'package:flutter/material.dart';
import 'package:todai/time_blocks/data.dart';

// todo validate todo text before calling onEdit
class TimeBlockInput extends StatefulWidget {
  static const TextStyle invertTextStyle =
      TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0));
  final TimeBlock timeBlock;
  final VoidCallback onBlur;
  final TimeBlockEditCallback onEdit;

  const TimeBlockInput(
      {super.key,
      required this.timeBlock,
      required this.onBlur,
      required this.onEdit});

  @override
  State<TimeBlockInput> createState() => _TimeBlockInputState();
}

class _TimeBlockInputState extends State<TimeBlockInput> {
  final TextEditingController _controller = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(border: InputBorder.none),
      style: TimeBlockInput.invertTextStyle,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        widget.onBlur();
      },
      onSubmitted: (s) => widget.onEdit(widget.timeBlock.index, s),
      onTapOutside: (PointerDownEvent e) {
        // todo prompt user if a change has been made that would be lost
        FocusScope.of(context).unfocus();
        widget.onBlur();
      },
    );
  }
}
