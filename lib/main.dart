import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'boomerang.dart';
import 'day.dart';
import 'dimensions.dart';
import 'time_blocks/count.dart';
import 'time_blocks/group.dart';

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
    const todoCount = BlockCount.four;
    final mediaQuery = MediaQuery.of(context);
    final dimensions = TodaiDimensions.fromMediaQuery(mediaQuery, todoCount);
    return TodaiScreen(todoCount: todoCount, dimensions: dimensions);
  }
}

class TodaiScreen extends StatefulWidget {
  final BlockCount todoCount;
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
                      blockCount: widget.todoCount,
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
