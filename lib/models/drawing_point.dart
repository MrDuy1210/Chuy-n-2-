import 'dart:ui';

class DrawingPoint {
  final Offset offset;
  final double strokeWidth;
  final Color color;
  final bool isEraser;

  DrawingPoint({
    required this.offset,
    required this.strokeWidth,
    required this.color,
    this.isEraser = false,
  });
}
