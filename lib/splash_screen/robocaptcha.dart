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

class RoboCaptcha extends StatefulWidget {
  final BoxesGrid boxesGrid;
  final TodaiDimensions dimensions;
  final VoidCallback onFinished;

  const RoboCaptcha(
      {super.key,
      required this.boxesGrid,
      required this.dimensions,
      required this.onFinished});

  @override
  State<RoboCaptcha> createState() => _RoboCaptchaState();
}

class _RoboCaptchaState extends State<RoboCaptcha> {
  static const duration = Duration(milliseconds: 500);
  late Offset boxOffset = createBoxOffset();
  int counter = 0;
  bool hideTopText = false;
  bool renderBox = false;
  bool renderButton = false;
  bool showBottomText = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(duration * 1.5, () {
      setState(() => renderBox = true);
    });
  }

  Offset createBoxOffset() {
    final random = Random();
    final top =
        random.nextInt((widget.dimensions.screenSize.height * .2).floor()) +
            widget.dimensions.screenSize.height * .7;
    final dx = (random.nextDouble() *
            (widget.dimensions.windowSize.width -
                (widget.boxesGrid.boxSize.width * 3)) +
        widget.boxesGrid.boxSize.width);
    return Offset(dx, top);
  }

  @override
  Widget build(BuildContext context) {
    final top = .15 * widget.dimensions.screenSize.height;
    final left = .15 * widget.dimensions.screenSize.width;
    return Padding(
      padding: EdgeInsets.only(top: widget.dimensions.devicePadding.top),
      child: Stack(children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedOpacity(
              curve: Curves.easeIn,
              duration: duration,
              opacity: hideTopText && verifiedNotRobot() ? 0 : 1,
              child: const MultiLineText(
                  text: ["Let's verify", "you're a human."]),
            ),
            const SizedBox(height: 20),
            MultiLineText(
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
            const SizedBox(height: 20),
            AnimatedOpacity(
              curve: Curves.easeIn,
              duration: duration,
              opacity: showBottomText && verifiedNotRobot() ? 1 : 0,
              child: const MultiLineText(text: ["Okay, you *seem* human."]),
            )
          ]),
        ),
        Positioned(
            bottom: .15 * widget.dimensions.screenSize.height,
            left: left,
            child: AnimatedOpacity(
              curve: Curves.ease,
              duration: duration * 2,
              opacity: renderButton && verifiedNotRobot() ? 1 : 0,
              child: GestureDetector(
                  onTap: verifiedNotRobot() ? widget.onFinished : null,
                  child: Container(
                      height: 60,
                      width: widget.dimensions.screenSize.width - (left * 2),
                      color: Colors.green,
                      child: const Center(
                          child: Text('Continue',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24))))),
            )),
        if (renderBox && !verifiedNotRobot()) buildBox(),
      ]),
    );
  }

  bool verifiedNotRobot() {
    return counter >= verified.length;
  }

  onWhacked() {
    setState(() {
      counter++;
      renderBox = false;
    });
    if (verifiedNotRobot()) {
      Future.delayed(duration, () => setState(() => hideTopText = true));
      Future.delayed(duration * 2, () => setState(() => showBottomText = true));
      Future.delayed(duration * 4, () => setState(() => renderButton = true));
    } else {
      Future.delayed(duration, () {
        setBoxOffset(createBoxOffset());
        setState(() => renderBox = true);
      });
    }
  }

  setBoxOffset(Offset maybeUpdate) {
    final halfWidth = widget.dimensions.windowSize.width / 2;
    final dxMax = widget.dimensions.windowSize.width -
        (widget.boxesGrid.boxSize.width * 2);
    double dx = maybeUpdate.dx;
    double dy = maybeUpdate.dy;
    if ((boxOffset.dx < halfWidth && maybeUpdate.dx < halfWidth) ||
        (boxOffset.dx >= halfWidth && maybeUpdate.dx >= halfWidth)) {
      dx = min(dxMax, widget.dimensions.windowSize.width - maybeUpdate.dx);
    }
    boxOffset = Offset(dx, dy);
  }

  Widget buildBox() {
    return WhackchaBox(
        top: boxOffset.dy,
        left: boxOffset.dx,
        size: widget.boxesGrid.boxSize,
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
