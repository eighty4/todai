import 'package:flutter/material.dart';

import 'model.dart';

typedef TapCallback = void Function(int);

class TimeBlockBox extends StatelessWidget {
  final TimeBlock todo;
  final double height;
  final bool minimized;
  final TapCallback onTap;

  const TimeBlockBox(
      {super.key,
      required this.height,
      required this.todo,
      required this.minimized,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(todo.id),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedSize(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 150),
          child: content(),
        ),
      ),
    );
  }

  Widget content() {
    if (minimized) {
      return Container(
        decoration: decoration(),
        constraints: BoxConstraints.expand(height: height / 5),
      );
    } else {
      return Container(
          decoration: decoration(),
          constraints: BoxConstraints.expand(height: height),
          child: Center(
            child: Text(todo.label,
                style: const TextStyle(
                    fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
          ));
    }
  }

  BoxDecoration decoration() {
    if (!minimized && todo.placeholder) {
      return const BoxDecoration(color: Color.fromARGB(255, 70, 70, 70));
    }
    return const BoxDecoration(color: Colors.black);
  }
}
