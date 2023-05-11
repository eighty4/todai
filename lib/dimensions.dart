import 'package:flutter/widgets.dart';
import 'time_blocks/box.dart';
import 'time_blocks/count.dart';

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
    final windowHeight = (mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom);
    final double blockHeight = blockCount == TimeBlockCount.four ? 80 : 80;
    final spaceAboveBlocks = (windowHeight / 2) -
        (((blockHeight * blockCount.toInt()) +
                (TimeBlockBox.marginHeight * 3)) /
            2);
    double spaceAboveBlocksEditing =
        (TimeBlockBox.minimizedHeight + TimeBlockBox.marginHeight) * 2;
    return TodaiDimensions(
      blockHeight: blockHeight,
      devicePadding: mediaQuery.padding,
      edgePadding: .08 * size.width,
      gutterWidth: .2 * size.width,
      spaceAboveBlocks: spaceAboveBlocks,
      spaceAboveBlocksEditing: spaceAboveBlocksEditing,
      windowSize: size,
    );
  }
}
