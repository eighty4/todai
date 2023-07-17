import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todai/time_blocks/count.dart';

typedef TimeBlockCallback = void Function(int);

typedef TimeBlockEditCallback = void Function(int, String);

class TimeBlock {
  final int index;
  final String text;
  final bool placeholder;

  TimeBlock(
      {required this.index, required this.text, this.placeholder = false});
}

class TimeBlockData {
  static Future<List<TimeBlock>> getTodos(TimeBlockCount blockCount) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = prefs.getStringList('todos') ?? List.empty();
    final placeholdersNeeded = blockCount.toInt() -
        todos.length +
        todos.where((todo) => todo == '').length;
    final List<String> placeholders = getRandomTimeBlocks(placeholdersNeeded);
    final result = List.generate(blockCount.toInt(), (i) {
      String todo = i >= todos.length ? '' : todos[i];
      bool placeholder = false;
      if (todo == '') {
        todo = placeholders.removeLast();
        placeholder = true;
      }
      return TimeBlock(index: i, text: todo, placeholder: placeholder);
    });
    return result;
  }

  static Future setTodos(List<TimeBlock> todos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todos',
        todos.map((todo) => todo.placeholder ? '' : todo.text).toList());
  }
}

class TimeBlockState {
  static const reset = TimeBlockState(display: true);

  const TimeBlockState({this.editing, required this.display});

  const TimeBlockState.editing(this.editing) : display = true;

  final int? editing;
  final bool display;

  bool isEditingActive() {
    return editing != null;
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

List<String> getRandomTimeBlocks(int count) {
  final random = Random();
  List<int> todos = [];
  do {
    final i = random.nextInt(randomLabels.length);
    if (!todos.contains(i)) {
      todos.add(i);
    }
  } while (todos.length < count);
  return todos.map((i) => randomLabels[i]).toList();
}
