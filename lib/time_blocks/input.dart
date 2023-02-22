import 'package:flutter/material.dart';
import 'model.dart';

class TimeBlockInput extends StatefulWidget {
  final double height;
  final void Function() onClose;
  final void Function(TimeBlock) onChange;
  final TimeBlock todo;

  const TimeBlockInput(
      {super.key,
      required this.height,
      required this.onClose,
      required this.onChange,
      required this.todo});

  @override
  State<StatefulWidget> createState() => _TimeBlockInputState();
}

class _TimeBlockInputState extends State<TimeBlockInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final text = widget.todo.placeholder ? '' : widget.todo.label;
    _controller = TextEditingController(text: text);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // creates an EdgeInsets.bottom with the size of the software keyboard
    // print(EdgeInsets.fromWindowPadding(
    //     WidgetsBinding.instance.window.viewInsets,
    //     WidgetsBinding.instance.window.devicePixelRatio));
    return Container(
      color: Colors.black,
      height: widget.height,
      child: Center(
        child: TextField(
          controller: _controller,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: InputBorder.none),
          style: const TextStyle(
              fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
          onEditingComplete: () => close(context),
          onTapOutside: (PointerDownEvent e) => close(context),
        ),
      ),
    );
  }

  void close(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_controller.text.isEmpty) {
      if (!widget.todo.placeholder) {
        // todo state change event/callback to remove and substitute placeholder
        widget.onChange(TimeBlock(
            id: widget.todo.id,
            label: getRandomTimeBlocks(1)[0].label,
            placeholder: true));
      }
    } else {
      widget.onChange(TimeBlock(
          id: widget.todo.id, label: _controller.text, placeholder: false));
    }
    widget.onClose();
  }
}
