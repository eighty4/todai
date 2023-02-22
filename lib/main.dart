import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'day.dart';
import 'dimensions.dart';
import 'time_blocks/count.dart';
import 'time_blocks/ui.dart';

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
    const blockCount = BlockCount.four;
    final mediaQuery = MediaQuery.of(context);
    final dimensions = TodaiDimensions.fromMediaQuery(mediaQuery, blockCount);
    return TodaiScreen(blockCount: blockCount, dimensions: dimensions);
  }
}

class TodaiScreen extends StatefulWidget {
  final BlockCount blockCount;
  final TodaiDimensions dimensions;

  const TodaiScreen(
      {super.key, required this.blockCount, required this.dimensions});

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
          child: TimeBlocksUi(
              blockCount: widget.blockCount, dimensions: widget.dimensions),
        ),
      ),
    );
  }
}
