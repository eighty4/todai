import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

void main() {
  runApp(const TodaiApp());
}

class TodaiApp extends StatelessWidget {
  const TodaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(backgroundColor: Colors.white),
      home: const ResponsiveTodaiScreen(),
    );
  }
}

class ResponsiveTodaiScreen extends StatelessWidget {
  const ResponsiveTodaiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const todoCount = TodoCount.four;
    final todoDimensions = TodoDimensions.fromScreenSize(size, todoCount);
    final edgePadding = (size.width * .2);
    return TodaiScreen(
        todoCount: todoCount,
        todoDimensions: todoDimensions,
        edgePadding: edgePadding,
        size: size);
  }
}

class TodaiScreen extends StatefulWidget {
  final TodoCount todoCount;
  final TodoDimensions todoDimensions;
  final double edgePadding;
  final Size size;

  const TodaiScreen(
      {super.key,
      required this.todoCount,
      required this.todoDimensions,
      required this.edgePadding,
      required this.size});

  @override
  State<TodaiScreen> createState() => _TodaiScreenState();
}

class _TodaiScreenState extends State<TodaiScreen> {
  late TodoDay day;

  @override
  void initState() {
    super.initState();
    day = TodoDay.today;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: calcPositionFromLeft(),
              bottom: 0,
              right: calcPositionFromRight(),
              child: TodoList(
                  day: day,
                  todoCount: widget.todoCount,
                  todoDimensions: widget.todoDimensions)),
          Boomerang(
              day: day,
              edgePadding: widget.edgePadding,
              windowSize: widget.size,
              onTap: () => setState(() => day = day.other())),
        ],
      ),
    );
  }

  double calcPositionFromRight() {
    return day == TodoDay.today
        ? widget.edgePadding
        : widget.todoDimensions.padding;
  }

  double calcPositionFromLeft() {
    return day == TodoDay.today
        ? widget.todoDimensions.padding
        : widget.edgePadding;
  }
}

enum TodoCount {
  four,
  five;
}

extension TodoDimensionFns on TodoCount {
  int numberOfTodos() {
    switch (this) {
      case TodoCount.four:
        return 4;
      case TodoCount.five:
        return 5;
    }
  }

  int numberOfTodoDivisions() => numberOfTodos() + 1;

  int numberOfPaddingDivisions() => numberOfTodoDivisions() + 1;

  double todoHeightProportion() {
    switch (this) {
      case TodoCount.four:
        return .16;
      case TodoCount.five:
        return .128; // 4 * .16 / 5
    }
  }

  double todoPaddingProportion() {
    return (1 - (todoHeightProportion() * numberOfTodoDivisions())) /
        numberOfPaddingDivisions();
  }
}

class TodoDimensions {
  static double calculateTodoHeight(Size size, TodoCount todoCount) {
    return size.height * todoCount.todoHeightProportion();
  }

  static double calculateTodoPadding(Size size, TodoCount todoCount) {
    return size.height * todoCount.todoPaddingProportion();
  }

  final double height;
  final double padding;

  TodoDimensions({required this.height, required this.padding});

  factory TodoDimensions.fromScreenSize(Size size, TodoCount todoCount) {
    return TodoDimensions(
        height: calculateTodoHeight(size, todoCount),
        padding: calculateTodoPadding(size, todoCount));
  }
}

class Boomerang extends StatelessWidget {
  static const double svgWidth = 35;
  static const double svgHeight = 70;
  static const double halfSvgWidth = svgWidth / 2;
  static const double halfSvgHeight = svgHeight / 2;

  final TodoDay day;
  final Size windowSize;
  final double edgePadding;
  final VoidCallback onTap;

  const Boomerang(
      {super.key,
      required this.day,
      required this.windowSize,
      required this.edgePadding,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final positionedFromTop = windowSize.height / 2 - halfSvgHeight;
    final positionedFromEdge = edgePadding / 2 - halfSvgWidth;
    final svg = GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset("assets/boomerang.svg",
          height: svgHeight,
          width: svgWidth,
          alignment: Alignment.center,
          color: Colors.black,
          fit: BoxFit.contain),
    );
    switch (day) {
      case TodoDay.today:
        return Positioned(
          top: positionedFromTop,
          right: positionedFromEdge,
          child: svg,
        );
      case TodoDay.tomorrow:
        return Positioned(
          top: positionedFromTop,
          left: positionedFromEdge,
          child: svg,
        );
    }
  }
}

class TodoList extends StatelessWidget {
  final TodoDay day;
  final TodoCount todoCount;
  final TodoDimensions todoDimensions;

  const TodoList(
      {super.key,
      required this.day,
      required this.todoCount,
      required this.todoDimensions});

  @override
  Widget build(BuildContext context) {
    final todos = getRandomTodos(todoCount.numberOfTodos());
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DayHeader(day: day, todoDimensions: todoDimensions),
          ...todos
              .map((label) => TodoBox(
                  selected: 0,
                  label: label,
                  height: todoDimensions.height,
                  placeholder: false))
              .toList(),
        ]);
  }
}

class DayHeader extends StatelessWidget {
  static const labelStyle = TextStyle(fontSize: 46);

  final TodoDay day;
  final TodoDimensions todoDimensions;

  const DayHeader({super.key, required this.day, required this.todoDimensions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: todoDimensions.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
                left: todoDimensions.padding, bottom: todoDimensions.padding),
            child: Text(day.label(), style: labelStyle),
          ),
          Container(
            constraints: const BoxConstraints.expand(height: 3),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

enum TodoDay { today, tomorrow }

extension TodoDayFns on TodoDay {
  String label() {
    switch (this) {
      case TodoDay.today:
        return 'Today';
      case TodoDay.tomorrow:
        return 'Tomorrow';
    }
  }

  TodoDay other() {
    return this == TodoDay.tomorrow ? TodoDay.today : TodoDay.tomorrow;
  }
}

class TodoBox extends StatelessWidget {
  final int selected;
  final String label;
  final bool placeholder;
  final double height;

  const TodoBox(
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
