import 'package:flutter/material.dart';
import 'box.dart';

class AnimatedEditingStripe extends StatefulWidget {
  final Interval interval;
  final double top;
  final double width;

  const AnimatedEditingStripe(
      {super.key,
      required this.interval,
      required this.top,
      required this.width});

  @override
  State<AnimatedEditingStripe> createState() => _AnimatedEditingStripeState();
}

class _AnimatedEditingStripeState extends State<AnimatedEditingStripe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _left;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _left = Tween<double>(begin: widget.width, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.interval,
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
    return Positioned(
      right: _left.value,
      top: widget.top,
      child: Container(
          height: TimeBlockBox.minimizedHeight,
          width: widget.width,
          color: Colors.white),
    );
  }
}
