import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todai/background.dart';
import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/intro.dart';
import 'package:todai/state.dart';
import 'package:todai/time_blocks/count.dart';
import 'package:todai/time_blocks/stack.dart';

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

class TodaiScreen extends StatefulWidget {
  const TodaiScreen({Key? key}) : super(key: key);

  @override
  State<TodaiScreen> createState() => _TodaiScreenState();
}

class _TodaiScreenState extends State<TodaiScreen> {
  TimeBlockCount blockCount = TimeBlockCount.four;
  bool stateLoaded = false;
  bool introPassed = false;

  @override
  void initState() {
    super.initState();
    TodaiAppState.hasPassedIntro().then((hasPassedIntro) {
      setState(() {
        stateLoaded = true;
        introPassed = hasPassedIntro;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!stateLoaded) {
      return const Center();
    }
    final mediaQuery = MediaQuery.of(context);
    final dimensions = TodaiDimensions.fromMediaQuery(mediaQuery, blockCount);
    if (!introPassed) {
      return IntroSequence(dimensions: dimensions, onFinished: onIntroFinished);
    } else {
      return Padding(
        padding: dimensions.devicePadding,
        child: TimeBlockStack(blockCount: blockCount, dimensions: dimensions),
      );
    }
  }

  void onIntroFinished() async {
    setState(() {
      introPassed = true;
    });
    await TodaiAppState.setPassedIntro();
  }
}
