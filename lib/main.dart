import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dimensions.dart';
import 'time_blocks/count.dart';
import 'time_blocks/stack.dart';

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
    const blockCount = TimeBlockCount.four;
    final mediaQuery = MediaQuery.of(context);
    final dimensions = TodaiDimensions.fromMediaQuery(mediaQuery, blockCount);
    return TodaiScreen(blockCount: blockCount, dimensions: dimensions);
  }
}

class TodaiScreen extends StatefulWidget {
  final TimeBlockCount blockCount;
  final TodaiDimensions dimensions;

  const TodaiScreen(
      {super.key, required this.blockCount, required this.dimensions});

  @override
  State<TodaiScreen> createState() => _TodaiScreenState();
}

class _TodaiScreenState extends State<TodaiScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;
  bool editing = false;
  Brightness brightness = Brightness.dark;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _color = ColorTween(begin: Colors.white, end: Colors.black).animate(
      CurvedAnimation(
        curve: const Interval(.4, .6, curve: Curves.ease),
        parent: _controller,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
    ));
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(color: _color.value, child: child);
        },
        child: Padding(
          padding: widget.dimensions.devicePadding,
          child: TimeBlockStack(
              blockCount: TimeBlockCount.four,
              dimensions: widget.dimensions,
              onEditing: onEditing),
        ),
      ),
    );
  }

  onEditing(bool editing) {
    _controller.animateTo(editing ? 0 : 1);
    setState(() {
      this.editing = editing;
      brightness = editing ? Brightness.dark : Brightness.light;
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {});
      }
    });
  }
}
