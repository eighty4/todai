import 'dart:async';
import 'dart:math';

import 'package:todai/time_blocks/count.dart';

class TimeBlock {
  final int index;
  final String text;
  final bool placeholder;

  TimeBlock(
      {required this.index, required this.text, this.placeholder = false});
}

class TimeBlockEvent {
  static const initialState = TimeBlockEvent(display: true);

  const TimeBlockEvent({this.editing, required this.display});

  final int? editing;
  final bool display;
}

class TheTimeBlockController {
  final StreamController<TimeBlockEvent> _streamController =
      StreamController.broadcast();
  final List<TimeBlock> _todos;

  TheTimeBlockController(TimeBlockCount blockCount)
      : _todos = getRandomTimeBlocks(blockCount.toInt());

  Stream<TimeBlockEvent> get stream => _streamController.stream;

  void focusEditing(int index) {
    _streamController.add(TimeBlockEvent(display: true, editing: index));
  }

  TimeBlock timeBlock(int index) {
    return _todos[index];
  }

  void blurEditing() {
    _streamController.add(TimeBlockEvent.initialState);
  }

  Future close() {
    return _streamController.close();
  }
}

const randomLabels = <String>[
  'Woodworking project',
  'Eat spinach',
  'Wash car',
  'Buy groceries',
  'Update résumé',
  'Bake muffins',
  'Clean kitchen',
  'Alphabetize DVDs',
  'Build robotics',
  'Petition Congress',
  'Inbox zero',
  'Study homework',
  'Water plants',
  'Write letter',
  'Daily exercise',
  'Call friend',
  'Cook dinner',
  'Read book',
  'Write essay',
  'Walk dog',
  'Pay bills',
  'Buy gift',
  'Make bed',
  'Oil change',
  'Take nap',
  'Book flight',
  'Schedule appointment',
  'Practice guitar',
];

List<TimeBlock> getRandomTimeBlocks(int count) {
  final random = Random();
  List<int> todos = [];
  do {
    final i = random.nextInt(randomLabels.length);
    if (!todos.contains(i)) {
      todos.add(i);
    }
  } while (todos.length < count);
  int id = 0;
  return todos
      .map((i) =>
          TimeBlock(index: id++, text: randomLabels[i], placeholder: true))
      .toList();
}
