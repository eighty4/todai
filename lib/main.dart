import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todai/background.dart';
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
    return ChangeNotifierProvider(
        create: (context) => TodaiBackground(),
        child: MaterialApp(
            title: 'Todai',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            home: const Scaffold(
                body: TodaiAppBackground(child: TodaiScreen()))));
  }
}

class TodaiScreen extends StatelessWidget {
  const TodaiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const blockCount = TimeBlockCount.four;
    final mediaQuery = MediaQuery.of(context);
    final dimensions = TodaiDimensions.fromMediaQuery(mediaQuery, blockCount);
    return Padding(
      padding: dimensions.devicePadding,
      child: TimeBlockStack(blockCount: blockCount, dimensions: dimensions),
    );
  }
}
