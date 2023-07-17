import 'package:flutter/material.dart';
import 'package:todai/time_blocks/data.dart';

// todo validate todo text before calling onEdit
class TimeBlockInput extends StatelessWidget {
  static const TextStyle invertTextStyle =
      TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0));
  final int index;
  final VoidCallback onBlur;
  final TimeBlockEditCallback onEdit;

  const TimeBlockInput(
      {super.key,
      required this.index,
      required this.onBlur,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(border: InputBorder.none),
      style: invertTextStyle,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        onBlur();
      },
      onSubmitted: (s) => onEdit(index, s),
      onTapOutside: (PointerDownEvent e) {
        // todo prompt user if a change has been made that would be lost
        FocusScope.of(context).unfocus();
        onBlur();
      },
    );
  }
}
