import 'package:flutter/material.dart';
import '../day.dart';
import '../dimensions.dart';
import 'box.dart';
import 'count.dart';
import 'header.dart';
import 'input.dart';
import 'model.dart';

class TimeBlockGroup extends StatefulWidget {
  final Day day;
  final BlockCount blockCount;
  final TodaiDimensions dimensions;

  const TimeBlockGroup(
      {super.key,
      required this.day,
      required this.blockCount,
      required this.dimensions});

  @override
  State<TimeBlockGroup> createState() => _TimeBlockGroupState();
}

class _TimeBlockGroupState extends State<TimeBlockGroup> {
  int? editing;
  late List<TimeBlock> todos;

  @override
  void initState() {
    super.initState();
    todos = getRandomTimeBlocks(widget.blockCount.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildContent());
  }

  List<Widget> buildContent() {
    const padding = SizedBox(height: 10);
    final List<Widget> content = [
      TimeBlockHeader(day: widget.day, dimensions: widget.dimensions),
    ];
    for (var todo in todos) {
      content.add(padding);
      content.add(buildBlock(todo));
    }
    return content;
  }

  Widget buildBlock(TimeBlock todo) {
    if (editing == todo.id) {
      return TimeBlockInput(
          height: widget.dimensions.blockHeight,
          onClose: onInputClose,
          onChange: onTodoUpdate,
          todo: todo);
    } else {
      return TimeBlockBox(
          todo: todo,
          height: widget.dimensions.blockHeight,
          minimized: editing != null && editing != todo.id,
          onTap: onBlockTap);
    }
  }

  void onBlockTap(int id) {
    setState(() {
      editing = id;
    });
  }

  void onTodoUpdate(TimeBlock update) {
    todos[update.id] = update;
  }

  void onInputClose() {
    setState(() {
      editing = null;
    });
  }
}
