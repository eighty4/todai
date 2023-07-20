import 'package:flutter/material.dart';
import 'package:todai/dimensions.dart';

class CompletionSwiping {
  final double start;
  final double distance;
  final double? velocity;

  CompletionSwiping(this.start, this.distance, {this.velocity});

  CompletionSwiping.start(this.start)
      : distance = start,
        velocity = null;

  CompletionSwiping ongoing(double swiped) {
    return CompletionSwiping(start, distance + swiped);
  }

  CompletionSwiping end(double velocity) {
    return CompletionSwiping(start, distance, velocity: velocity);
  }

  bool get done => velocity != null;
}

class CompletionLine extends StatefulWidget {
  final Widget child;
  final TodaiDimensions dimensions;
  final CompletionSwiping? swiping;

  const CompletionLine(
      {super.key,
      required this.child,
      required this.dimensions,
      required this.swiping});

  @override
  State<StatefulWidget> createState() {
    return _CompletionLineState();
  }
}

class _CompletionLineState extends State<CompletionLine> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CompletionLinePainter(swiping: widget.swiping),
      size: Size(
          widget.dimensions.screenSize.width, widget.dimensions.blockHeight),
      child: widget.child,
    );
  }
}

class CompletionLinePainter extends CustomPainter {
  CompletionSwiping? swiping;

  CompletionLinePainter({required this.swiping});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final verticalCenter = size.height / 2;

    if (swiping == null || swiping!.done) {
      return;
    }

    canvas.drawLine(Offset(swiping!.start, verticalCenter),
        Offset(swiping!.distance, verticalCenter), paint);

    Path path = Path()
      ..moveTo(swiping!.start, verticalCenter)
      ..lineTo(swiping!.distance, verticalCenter);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CompletionLinePainter oldDelegate) {
    return swiping != oldDelegate.swiping;
  }
}
