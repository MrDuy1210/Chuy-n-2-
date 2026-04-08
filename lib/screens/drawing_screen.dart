import 'package:flutter/material.dart';
import '../models/drawing_point.dart';
import '../models/text_item.dart';
import '../utils/app_colors.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/color_picker_dialog.dart';
import '../widgets/stroke_width_dialog.dart';

enum DrawingMode { pen, eraser, text, icon }

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingPoint?> drawingPoints = [];
  List<TextItem> textItems = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  DrawingMode drawingMode = DrawingMode.pen;
  String selectedIcon = '⭐';

  final List<({List<DrawingPoint?> points, List<TextItem> texts})> _undoHistory = [];
  final List<({List<DrawingPoint?> points, List<TextItem> texts})> _redoHistory = [];

  bool get _canvasIsEmpty => drawingPoints.isEmpty && textItems.isEmpty;

  void _saveSnapshot() {
    _undoHistory.add((
      points: List.from(drawingPoints),
      texts: List.from(textItems),
    ));
    _redoHistory.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vẽ tranh'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Hoàn tác',
            onPressed: _undoHistory.isEmpty ? null : _undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            tooltip: 'Làm lại',
            onPressed: _redoHistory.isEmpty ? null : _redo,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Xoá tất cả',
            onPressed: _canvasIsEmpty ? null : () => _showClearDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Lưu tranh',
            onPressed: () => _showSaveDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Hint bar for current mode
          if (drawingMode == DrawingMode.text || drawingMode == DrawingMode.icon)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: AppColors.primary.withOpacity(0.08),
              child: Text(
                drawingMode == DrawingMode.text
                    ? 'Nhấn vào vùng vẽ để chèn chữ'
                    : 'Nhấn vào vùng vẽ để đặt biểu tượng "$selectedIcon"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Canvas
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                if (drawingMode == DrawingMode.pen || drawingMode == DrawingMode.eraser) {
                  setState(() {
                    _saveSnapshot();
                    drawingPoints.add(
                      DrawingPoint(
                        offset: details.localPosition,
                        strokeWidth: strokeWidth,
                        color: drawingMode == DrawingMode.eraser ? Colors.white : selectedColor,
                        isEraser: drawingMode == DrawingMode.eraser,
                      ),
                    );
                  });
                }
              },
              onPanUpdate: (details) {
                if (drawingMode == DrawingMode.pen || drawingMode == DrawingMode.eraser) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        offset: details.localPosition,
                        strokeWidth: strokeWidth,
                        color: drawingMode == DrawingMode.eraser ? Colors.white : selectedColor,
                        isEraser: drawingMode == DrawingMode.eraser,
                      ),
                    );
                  });
                }
              },
              onPanEnd: (details) {
                if (drawingMode == DrawingMode.pen || drawingMode == DrawingMode.eraser) {
                  setState(() {
                    drawingPoints.add(null); // separator
                  });
                }
              },
              onTapUp: (details) {
                if (drawingMode == DrawingMode.text) {
                  _showTextInputDialog(details.localPosition);
                } else if (drawingMode == DrawingMode.icon) {
                  setState(() {
                    _saveSnapshot();
                    textItems.add(TextItem(
                      offset: details.localPosition - const Offset(16, 16),
                      text: selectedIcon,
                      color: Colors.black,
                      fontSize: 32,
                      isEmoji: true,
                    ));
                  });
                }
              },
              child: CustomPaint(
                painter: DrawingCanvas(
                  drawingPoints: drawingPoints,
                  textItems: textItems,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          // Bottom Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Pen tool
                    _buildToolButton(
                      icon: Icons.edit,
                      label: 'Bút vẽ',
                      isSelected: drawingMode == DrawingMode.pen,
                      onTap: () => setState(() => drawingMode = DrawingMode.pen),
                    ),
                    const SizedBox(width: 4),
                    // Eraser tool
                    _buildToolButton(
                      icon: Icons.auto_fix_high,
                      label: 'Tẩy',
                      isSelected: drawingMode == DrawingMode.eraser,
                      onTap: () => setState(() => drawingMode = DrawingMode.eraser),
                    ),
                    const SizedBox(width: 4),
                    // Text tool
                    _buildToolButton(
                      icon: Icons.text_fields,
                      label: 'Chữ',
                      isSelected: drawingMode == DrawingMode.text,
                      onTap: () => setState(() => drawingMode = DrawingMode.text),
                    ),
                    const SizedBox(width: 4),
                    // Icon tool
                    _buildIconToolButton(),
                    const SizedBox(width: 4),
                    // Color picker
                    _buildColorButton(),
                    const SizedBox(width: 4),
                    // Stroke width
                    _buildToolButton(
                      icon: Icons.line_weight,
                      label: 'Độ dày',
                      isSelected: false,
                      onTap: () => _showStrokeWidthDialog(context),
                    ),
                    const SizedBox(width: 4),
                    // Quick colors
                    ..._buildQuickColors(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconToolButton() {
    final isSelected = drawingMode == DrawingMode.icon;
    return GestureDetector(
      onTap: _showIconPicker,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Text(selectedIcon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 4),
          Text(
            'Icon',
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton() {
    return GestureDetector(
      onTap: () => _showColorPickerDialog(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[400]!, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Màu sắc',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuickColors() {
    final quickColors = [
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
    ];
    return quickColors.map((color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = color;
            if (drawingMode == DrawingMode.eraser) {
              drawingMode = DrawingMode.pen;
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selectedColor == color && drawingMode != DrawingMode.eraser
                  ? AppColors.primary
                  : Colors.grey[300]!,
              width: selectedColor == color && drawingMode != DrawingMode.eraser ? 3 : 1,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showIconPicker() {
    final icons = [
      '⭐', '❤️', '😀', '😂', '🎉', '🔥', '👍', '✅',
      '❌', '🌈', '🎨', '🌟', '💫', '✨', '🌸', '🍀',
      '🎥', '🎦', '🌙', '☀️', '⚡', '💎', '🏆', '🎯',
      '🐱', '🐶', '🦋', '🌺', '🍕', '🚀', '💡', '👑',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn biểu tượng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: icons
                  .map(
                    (emoji) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = emoji;
                          drawingMode = DrawingMode.icon;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: selectedIcon == emoji
                              ? AppColors.primary.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedIcon == emoji
                                ? AppColors.primary
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showTextInputDialog(Offset position) {
    final controller = TextEditingController();
    double textFontSize = 24;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thêm văn bản'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Nhập nội dung...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Cỡ chữ:', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Slider(
                      value: textFontSize,
                      min: 12,
                      max: 72,
                      divisions: 12,
                      onChanged: (v) => setDialogState(() => textFontSize = v),
                    ),
                  ),
                  Text(
                    '${textFontSize.round()}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              onPressed: () {
                final trimmed = controller.text.trim();
                if (trimmed.isNotEmpty) {
                  setState(() {
                    _saveSnapshot();
                    textItems.add(TextItem(
                      offset: position,
                      text: trimmed,
                      color: selectedColor,
                      fontSize: textFontSize,
                    ));
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(
        selectedColor: selectedColor,
        onColorSelected: (color) {
          setState(() {
            selectedColor = color;
            if (drawingMode == DrawingMode.eraser) {
              drawingMode = DrawingMode.pen;
            }
          });
        },
      ),
    );
  }

  void _showStrokeWidthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StrokeWidthDialog(
        currentWidth: strokeWidth,
        selectedColor: selectedColor,
        onWidthChanged: (width) {
          setState(() {
            strokeWidth = width;
          });
        },
      ),
    );
  }

  void _undo() {
    if (_undoHistory.isNotEmpty) {
      setState(() {
        _redoHistory.add((
          points: List.from(drawingPoints),
          texts: List.from(textItems),
        ));
        final snapshot = _undoHistory.removeLast();
        drawingPoints = snapshot.points;
        textItems = snapshot.texts;
      });
    }
  }

  void _redo() {
    if (_redoHistory.isNotEmpty) {
      setState(() {
        _undoHistory.add((
          points: List.from(drawingPoints),
          texts: List.from(textItems),
        ));
        final snapshot = _redoHistory.removeLast();
        drawingPoints = snapshot.points;
        textItems = snapshot.texts;
      });
    }
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá tất cả'),
        content: const Text('Bạn có chắc chắn muốn xoá toàn bộ bản vẽ không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _saveSnapshot();
                drawingPoints.clear();
                textItems.clear();
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Xoá',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final nameController = TextEditingController(
      text: 'Bức tranh ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lưu tranh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên bức tranh',
                hintText: 'Nhập tên bức tranh...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã lưu "${nameController.text}" thành công!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    if (_canvasIsEmpty) {
      Navigator.pop(context);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thoát'),
        content: const Text(
          'Bạn có muốn lưu bản vẽ trước khi thoát không?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text('Không lưu'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tiếp tục vẽ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _showSaveDialog(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
