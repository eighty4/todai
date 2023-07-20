import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/time_blocks/count.dart';
import 'package:todai/time_blocks/data.dart';
import 'package:todai/time_blocks/stack.dart';

class TimeBlockUserInterface extends StatefulWidget {
  final TimeBlockCount blockCount;
  final TodaiDimensions dimensions;

  const TimeBlockUserInterface(
      {Key? key, required this.blockCount, required this.dimensions})
      : super(key: key);

  @override
  State<TimeBlockUserInterface> createState() => _TimeBlockUserInterfaceState();
}

class _TimeBlockUserInterfaceState extends State<TimeBlockUserInterface> {
  List<TimeBlock>? todos;

  @override
  void initState() {
    super.initState();
    TimeBlockData.getTodos(widget.blockCount).then((todos) {
      setState(() {
        this.todos = todos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      return const SizedBox(height: 3);
    } else {
      return TimeBlockStack(
          blockCount: widget.blockCount,
          dimensions: widget.dimensions,
          onComplete: onComplete,
          onEdit: onEdit,
          todos: todos!);
    }
  }

  void onComplete(int index) {
    setState(() {
      todos![index] = TimeBlock.completed(todos![index]);
    });
    TimeBlockData.setTodos(todos!).then((value) {});
  }

  void onEdit(int index, String text) {
    setState(() {
      todos![index] = TimeBlock(index: index, text: text);
    });
    TimeBlockData.setTodos(todos!).then((value) {});
  }
}
