import 'package:flutter/widgets.dart';

class TodaiDimensions {
  final double blockHeight;
  final EdgeInsets devicePadding;
  final double edgePadding;
  final double gutterWidth;
  final Size screenSize;
  final Size windowSize;

  TodaiDimensions(
      {required this.blockHeight,
      required this.devicePadding,
      required this.edgePadding,
      required this.gutterWidth,
      required this.windowSize})
      : screenSize = Size(
            windowSize.width - devicePadding.left - devicePadding.right,
            windowSize.height - devicePadding.top - devicePadding.bottom);

  factory TodaiDimensions.fromMediaQuery(
      MediaQueryData mediaQuery, double verticalBlockProportion) {
    final size = mediaQuery.size;
    return TodaiDimensions(
      blockHeight: verticalBlockProportion * size.height,
      devicePadding: mediaQuery.padding,
      edgePadding: .08 * size.width,
      gutterWidth: .2 * size.width,
      windowSize: size,
    );
  }
}
