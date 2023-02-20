import 'dart:math';
import 'package:flutter/material.dart';
import '../day.dart';
import '../dimensions.dart';
import 'count.dart';
import 'box.dart';
import 'header.dart';

const randomTodoLabels = <String>[
  'Woodworking project',
  'Eat spinach',
  'Wash car',
  'Buy groceries',
  'Update résumé',
  'Bake muffins',
  'Clean bathroom',
  'Build robotics',
  'Practice guitar',
  'Study homework',
  'Write letter',
];

final random = Random();

List<String> getRandomTodos(int count) {
  List<int> todos = [];
  do {
    final i = random.nextInt(randomTodoLabels.length);
    if (!todos.contains(i)) {
      todos.add(i);
    }
  } while (todos.length < count);
  return todos.map((i) => randomTodoLabels[i]).toList();
}

class TimeBlockScreen extends StatelessWidget {
  final Day day;
  final BlockCount blockCount;
  final TodaiDimensions dimensions;

  const TimeBlockScreen(
      {super.key,
      required this.day,
      required this.blockCount,
      required this.dimensions});

  @override
  Widget build(BuildContext context) {
    final todos = getRandomTodos(blockCount.toInt());
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimeBlockHeader(day: day, dimensions: dimensions),
          ...todos
              .map((label) => TimeBlockBox(
                  selected: 0,
                  label: label,
                  height: dimensions.blockHeight,
                  placeholder: false))
              .toList(),
          SizedBox(
            height: dimensions.blockHeight / 2,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ]);
  }
}
