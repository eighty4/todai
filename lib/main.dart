import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boomerang.dart';
import 'day.dart';
import 'dimensions.dart';

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
      theme: ThemeData(),
      home: const ResponsiveTodaiScreen(),
    );
  }
}

class ResponsiveTodaiScreen extends StatelessWidget {
  const ResponsiveTodaiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const todoCount = TodoCount.four;
    final mediaQuery = MediaQuery.of(context);
    final dimensions = TodaiDimensions.fromMediaQuery(
        mediaQuery, todoCount.screenHeightProportion());

    return TodaiScreen(todoCount: todoCount, dimensions: dimensions);
  }
}

class TodaiScreen extends StatefulWidget {
  final TodoCount todoCount;
  final TodaiDimensions dimensions;

  const TodaiScreen(
      {super.key, required this.todoCount, required this.dimensions});

  @override
  State<TodaiScreen> createState() => _TodaiScreenState();
}

class _TodaiScreenState extends State<TodaiScreen> {
  late Day day;

  @override
  void initState() {
    super.initState();
    day = Day.today;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Padding(
        padding: widget.dimensions.devicePadding,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: calcPositionFromLeft(),
                  bottom: 0,
                  right: calcPositionFromRight(),
                  child: TimeBlockScreen(
                      day: day,
                      todoCount: widget.todoCount,
                      dimensions: widget.dimensions)),
              Boomerang(
                  day: day,
                  dimensions: widget.dimensions,
                  onTap: () => setState(() => day = day.other())),
            ],
          ),
        ),
      ),
    );
  }

  double calcPositionFromRight() {
    return day == Day.today
        ? widget.dimensions.gutterWidth
        : widget.dimensions.edgePadding;
  }

  double calcPositionFromLeft() {
    return day == Day.today
        ? widget.dimensions.edgePadding
        : widget.dimensions.gutterWidth;
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

  double screenHeightProportion() {
    switch (this) {
      case TodoCount.four:
        return 1 / 8; // 1 / 4 todos + 2 padding + 1 header + 1 footer
      case TodoCount.five:
        return 1 / 10; // 1 / 5 todos + 3 padding + 1 header + 1 footer
    }
  }
}

class TimeBlockScreen extends StatelessWidget {
  final Day day;
  final TodoCount todoCount;
  final TodaiDimensions dimensions;

  const TimeBlockScreen(
      {super.key,
      required this.day,
      required this.todoCount,
      required this.dimensions});

  @override
  Widget build(BuildContext context) {
    final todos = getRandomTodos(todoCount.numberOfTodos());
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

class TimeBlockHeader extends StatelessWidget {
  static const labelStyle = TextStyle(fontSize: 46);

  final Day day;
  final TodaiDimensions dimensions;

  const TimeBlockHeader(
      {super.key, required this.day, required this.dimensions});

  @override
  Widget build(BuildContext context) {
    // final lineHeight = dimensions.blockHeight;
    const double lineHeight = 0;
    return Container(
      color: Colors.transparent,
      child: SizedBox(
        height: dimensions.blockHeight,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: dimensions.blockHeight - lineHeight,
                child: Container(height: lineHeight, color: Colors.black)),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: dimensions.edgePadding),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(day.label(), style: labelStyle),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class TimeBlockBox extends StatelessWidget {
  final int selected;
  final String label;
  final bool placeholder;
  final double height;

  const TimeBlockBox(
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
