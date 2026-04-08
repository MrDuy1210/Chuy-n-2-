import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/drawing_point.dart';
import '../models/text_item.dart';

class DrawingCanvas extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  final List<TextItem> textItems;

  DrawingCanvas({required this.drawingPoints, this.textItems = const []});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw white background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        final paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke;

        if (drawingPoints[i]!.isEraser) {
          paint.color = Colors.white;
        }

        canvas.drawLine(
          drawingPoints[i]!.offset,
          drawingPoints[i + 1]!.offset,
          paint,
        );
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        // Single dot
        final paint = Paint()
          ..color = drawingPoints[i]!.color
          ..strokeWidth = drawingPoints[i]!.strokeWidth
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true;

        if (drawingPoints[i]!.isEraser) {
          paint.color = Colors.white;
        }

        canvas.drawPoints(
          ui.PointMode.points,
          [drawingPoints[i]!.offset],
          paint,
        );
      }
    }

    // Draw text and emoji items
    for (final item in textItems) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: item.text,
          style: TextStyle(
            color: item.color,
            fontSize: item.fontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, item.offset);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingCanvas oldDelegate) => true;
}
