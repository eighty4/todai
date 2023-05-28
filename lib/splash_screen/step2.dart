import 'dart:math';

import 'package:flutter/material.dart';

import 'package:todai/dimensions.dart';
import 'package:todai/splash_screen/boxes.dart';

const verified = [
  'Cognitive ability',
  'Persistence',
  'Tapping addiction',
  'Blind faith',
];

class IntroStep2 extends StatefulWidget {
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  const IntroStep2(
      {super.key, required this.dimensions, required this.onFinished});

  @override
  State<IntroStep2> createState() => _IntroStep2State();
}

class _IntroStep2State extends State<IntroStep2> {
  int counter = 0;
  bool renderTappable = false;

  @override
  void initState() {
    super.initState();
    queueRender();
  }

  void queueRender() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => renderTappable = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = .2 * widget.dimensions.screenSize.height;
    final left = .125 * widget.dimensions.screenSize.width;
    return Padding(
      padding: EdgeInsets.only(top: widget.dimensions.devicePadding.top),
      child: Stack(children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: verifiedNotRobot()
              ? const MultiLineText(text: ["Okay, you *seem* human."])
              : const MultiLineText(text: ["Let's verify", "you're a human."]),
        ),
        if (counter > 0)
          Positioned(
            top: top + 84,
            left: left,
            child: MultiLineText(
              text: List.generate(counter, (i) => verified[i]),
              rowBuilder: (text) => Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.check, color: Colors.green, size: 28)),
                  text
                ],
              ),
            ),
          ),
        if (renderTappable && !verifiedNotRobot()) buildBox(),
        if (renderTappable && verifiedNotRobot())
          Positioned(
              bottom: .15 * widget.dimensions.screenSize.height,
              left: left,
              child: GestureDetector(
                  onTap: widget.onFinished,
                  child: Container(
                      height: 60,
                      width: widget.dimensions.screenSize.width - (left * 2),
                      color: Colors.green,
                      child: const Center(
                          child: Text('Continue',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24)))))),
      ]),
    );
  }

  bool verifiedNotRobot() {
    return counter >= verified.length;
  }

  onWhacked() {
    setState(() {
      counter++;
      renderTappable = false;
    });
    Future.delayed(const Duration(milliseconds: 500),
        () => setState(() => renderTappable = true));
  }

  Widget buildBox() {
    final top =
        Random().nextInt((widget.dimensions.screenSize.height * .2).floor()) +
            widget.dimensions.screenSize.height * .7;
    final left =
        Random().nextInt((widget.dimensions.screenSize.width * .7).floor()) +
            (widget.dimensions.screenSize.width * .15);
    return WhackchaBox(
        top: top.toDouble(),
        left: left.toDouble(),
        size: BoxesGrid.forDimensions(widget.dimensions).boxSize,
        onWhacked: onWhacked);
  }
}

class MultiLineText extends StatelessWidget {
  final Widget Function(Widget)? rowBuilder;
  final List<String> text;

  const MultiLineText({super.key, required this.text, this.rowBuilder});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(text.length, (i) {
          Widget row = Text(text[i],
              style: const TextStyle(color: Colors.white, fontSize: 24));
          if (rowBuilder != null) {
            row = rowBuilder!(row);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: row,
          );
        }));
  }
}

class WhackchaBox extends StatelessWidget {
  final double top;
  final double left;
  final Size size;
  final VoidCallback onWhacked;

  const WhackchaBox(
      {super.key,
      required this.top,
      required this.left,
      required this.size,
      required this.onWhacked});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        left: left,
        child: GestureDetector(
            onTap: onWhacked,
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.pink,
            )));
  }
}
