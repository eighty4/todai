import 'dart:math';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todai/time_blocks/count.dart';

typedef TimeBlockCallback = void Function(int);

typedef TimeBlockEditCallback = void Function(int, String);

enum TimeBlockStatus { completed, placeholder, todo }

class TimeBlock {
  final int index;
  final String text;
  final TimeBlockStatus status;

  TimeBlock(
      {required this.index,
      required this.text,
      this.status = TimeBlockStatus.todo});

  TimeBlock.completed(TimeBlock completed)
      : index = completed.index,
        text = completed.text,
        status = TimeBlockStatus.completed;

  TimeBlock.placeholder({required this.index, required this.text})
      : status = TimeBlockStatus.placeholder;

  bool get completed => status == TimeBlockStatus.completed;

  bool get placeholder => status == TimeBlockStatus.placeholder;

  bool get isAYetToDoTodo => status == TimeBlockStatus.todo;

  @override
  String toString() {
    return 'TimeBlock{index: $index, text: $text, status: $status}';
  }
}

class TimeBlockData {
  static Future<List<TimeBlock>> getTodos(TimeBlockCount blockCount) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = prefs.getStringList('today') ?? List.empty();
    final placeholdersNeeded = blockCount.toInt() -
        todos.length +
        todos.where((todo) => todo == '').length;
    final List<String> placeholders = getRandomTimeBlocks(placeholdersNeeded);
    final result = List.generate(blockCount.toInt(), (i) {
      String todo = i >= todos.length ? '' : todos[i];
      TimeBlockStatus status = TimeBlockStatus.todo;
      if (todo == '') {
        todo = placeholders.removeLast();
        status = TimeBlockStatus.placeholder;
      }
      return TimeBlock(index: i, text: todo, status: status);
    });
    return result;
  }

  static Future setTodos(List<TimeBlock> todos) async {
    await _setTodos(await SharedPreferences.getInstance(), todos);
  }

  static Future _setTodos(
      SharedPreferences prefs, List<TimeBlock> todos) async {
    await prefs.setStringList(
        'today',
        todos.map((todo) {
          return todo.completed || todo.placeholder ? '' : todo.text;
        }).toList());
  }

  static Future complete(List<TimeBlock> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final settingTodayRemainingTodos = _setTodos(prefs, todos);
    final completed =
        todos.where((element) => element.completed).map((e) => e.text).toList();
    if (completed.isNotEmpty) {
      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final saved = prefs.getStringList(todayKey);
      if (saved != null) {
        completed.addAll(saved);
        await prefs.setStringList(todayKey, completed);
      }
    }
    await settingTodayRemainingTodos;
  }
}

class TimeBlockUiState {
  static const reset = TimeBlockUiState(display: true);

  const TimeBlockUiState({this.editing, required this.display});

  const TimeBlockUiState.editing(this.editing) : display = true;

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
