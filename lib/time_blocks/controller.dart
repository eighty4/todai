import 'dart:math';

class TimeBlock {
  final int index;
  final String text;
  final bool placeholder;

  TimeBlock(
      {required this.index, required this.text, this.placeholder = false});
}

class TimeBlockState {
  static const reset = TimeBlockState(display: true);

  const TimeBlockState({this.editing, required this.display});

  const TimeBlockState.editing(this.editing) : display = true;

  final int? editing;
  final bool display;
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
