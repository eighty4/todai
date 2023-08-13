import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todai/background.dart';

const completionDuration = Duration(milliseconds: 1500);
const transitionDuration = Duration(milliseconds: 750);

class BackgroundFade extends StatefulWidget {
  final BackgroundMode fadeToBackground;
  final VoidCallback onFinished;

  const BackgroundFade(
      {super.key, required this.fadeToBackground, required this.onFinished});

  @override
  State<BackgroundFade> createState() => _BackgroundFadeState();
}

class _BackgroundFadeState extends State<BackgroundFade> {
  late final Timer backgroundTimer;
  late final Timer completionTimer;

  @override
  void initState() {
    super.initState();
    backgroundTimer = Timer(transitionDuration, changeBackground);
    completionTimer = Timer(completionDuration, finish);
  }

  @override
  void dispose() {
    backgroundTimer.cancel();
    completionTimer.cancel();
    super.dispose();
  }

  void changeBackground() {
    TodaiBackground.of(context).update(widget.fadeToBackground);
  }

  void finish() {
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
