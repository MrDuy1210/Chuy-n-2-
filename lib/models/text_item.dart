import 'dart:ui';

class TextItem {
  final Offset offset;
  final String text;
  final Color color;
  final double fontSize;
  final bool isEmoji;

  TextItem({
    required this.offset,
    required this.text,
    required this.color,
    this.fontSize = 24,
    this.isEmoji = false,
  });
}
