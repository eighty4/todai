import 'package:flutter/widgets.dart';
import 'time_blocks/count.dart';

extension on BlockCount {
  double screenHeightProportion() {
    switch (this) {
      case BlockCount.four:
        return 1 / 8; // 1 / 4 todos + 2 padding + 1 header + 1 footer
      case BlockCount.five:
        return 1 / 10; // 1 / 5 todos + 3 padding + 1 header + 1 footer
    }
  }
}

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
      MediaQueryData mediaQuery, BlockCount blockCount) {
    final size = mediaQuery.size;
    return TodaiDimensions(
      blockHeight: blockCount.screenHeightProportion() * size.height,
      devicePadding: mediaQuery.padding,
      edgePadding: .08 * size.width,
      gutterWidth: .2 * size.width,
      windowSize: size,
    );
  }
}
