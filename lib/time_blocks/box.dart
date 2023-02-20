import 'package:flutter/material.dart';

class TimeBlockBox extends StatelessWidget {
  final int selected;
  final String label;
  final bool placeholder;
  final double height;

  const TimeBlockBox(
      {super.key,
        required this.height,
        required this.selected,
        required this.label,
        required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
          decoration: decoration(),
          constraints: BoxConstraints.expand(height: height),
          child: Center(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 22, color: Color.fromARGB(255, 255, 255, 255))),
          )),
    );
  }

  BoxDecoration decoration() {
    if (placeholder) {
      return const BoxDecoration(color: Color.fromARGB(255, 46, 46, 46));
    }
    return const BoxDecoration(color: Colors.black);
  }
}
