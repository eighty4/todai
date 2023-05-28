import 'dart:ui';

import 'package:todai/dimensions.dart';

class BoxesGrid {
  final Size boxSize;
  final int rows;
  final int columns;

  BoxesGrid({required this.boxSize, required this.rows, required this.columns});

  factory BoxesGrid.forDimensions(TodaiDimensions dimensions) {
    const columns = 15;
    final width = dimensions.screenSize.width / columns;
    final rows = ((dimensions.screenSize.height) / width).floor();
    final height = ((dimensions.screenSize.height) / rows).ceilToDouble();
    final boxSize = Size(width, height);
    return BoxesGrid(boxSize: boxSize, rows: rows, columns: columns);
  }
}
