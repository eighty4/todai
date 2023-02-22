import 'dart:math';

class TimeBlock {
  final int id;
  final String label;
  final bool placeholder;

  TimeBlock({required this.id, required this.label, required this.placeholder});
}

const randomLabels = <String>[
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
      .map(
          (i) => TimeBlock(id: id++, label: randomLabels[i], placeholder: true))
      .toList();
}
