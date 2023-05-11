import 'package:flutter/widgets.dart';
import 'time_blocks/box.dart';
import 'time_blocks/count.dart';
import 'time_blocks/stack.dart';

extension on TimeBlockCount {
  double screenHeightProportion() {
    switch (this) {
      case TimeBlockCount.four:
        return 1 / 8; // 1 / 4 todos + 2 padding + 1 header + 1 footer
      case TimeBlockCount.five:
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
  final double spaceAboveBlocks;
  final double spaceAboveBlocksEditing;

  TodaiDimensions(
      {required this.blockHeight,
      required this.devicePadding,
      required this.edgePadding,
      required this.gutterWidth,
      required this.spaceAboveBlocks,
      required this.spaceAboveBlocksEditing,
      required this.windowSize})
      : screenSize = Size(
            windowSize.width - devicePadding.left - devicePadding.right,
            windowSize.height - devicePadding.top - devicePadding.bottom);

  factory TodaiDimensions.fromMediaQuery(
      MediaQueryData mediaQuery, TimeBlockCount blockCount) {
    final size = mediaQuery.size;
    double spaceAboveBlocks =
        (size.height / 2) - (TimeBlockStack.blocksHeight / 2);
    double spaceAboveBlocksEditing =
        (TimeBlockBox.minimizedHeight + TimeBlockBox.marginHeight) * 2;
    return TodaiDimensions(
      blockHeight: blockCount.screenHeightProportion() * size.height,
      devicePadding: mediaQuery.padding,
      edgePadding: .08 * size.width,
      gutterWidth: .2 * size.width,
      spaceAboveBlocks: spaceAboveBlocks,
      spaceAboveBlocksEditing: spaceAboveBlocksEditing,
      windowSize: size,
    );
  }
}
