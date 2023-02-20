import 'package:flutter/material.dart';
import '../day.dart';
import '../dimensions.dart';

class TimeBlockHeader extends StatelessWidget {
  static const labelStyle = TextStyle(fontSize: 46);

  final Day day;
  final TodaiDimensions dimensions;

  const TimeBlockHeader(
      {super.key, required this.day, required this.dimensions});

  @override
  Widget build(BuildContext context) {
    // final lineHeight = dimensions.blockHeight;
    const double lineHeight = 0;
    return Container(
      color: Colors.transparent,
      child: SizedBox(
        height: dimensions.blockHeight,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: dimensions.blockHeight - lineHeight,
                child: Container(height: lineHeight, color: Colors.black)),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: dimensions.edgePadding),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(day.label(), style: labelStyle),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
