import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StrokeWidthDialog extends StatefulWidget {
  final double currentWidth;
  final Color selectedColor;
  final ValueChanged<double> onWidthChanged;

  const StrokeWidthDialog({
    super.key,
    required this.currentWidth,
    required this.selectedColor,
    required this.onWidthChanged,
  });

  @override
  State<StrokeWidthDialog> createState() => _StrokeWidthDialogState();
}

class _StrokeWidthDialogState extends State<StrokeWidthDialog> {
  late double _width;

  @override
  void initState() {
    super.initState();
    _width = widget.currentWidth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chọn độ dày nét vẽ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                width: 120,
                height: _width,
                decoration: BoxDecoration(
                  color: widget.selectedColor,
                  borderRadius: BorderRadius.circular(_width / 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Slider
          Row(
            children: [
              const Text('1'),
              Expanded(
                child: Slider(
                  value: _width,
                  min: 1.0,
                  max: 30.0,
                  divisions: 29,
                  label: _width.toStringAsFixed(1),
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _width = value;
                    });
                  },
                ),
              ),
              const Text('30'),
            ],
          ),
          Text(
            'Độ dày: ${_width.toStringAsFixed(1)} px',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          // Quick presets
          const Text(
            'Chọn nhanh:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1.0, 3.0, 5.0, 8.0, 12.0, 20.0].map((w) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _width = w;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _width == w ? AppColors.primary : Colors.grey[300]!,
                      width: _width == w ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: _width == w
                        ? AppColors.primary.withOpacity(0.1)
                        : null,
                  ),
                  child: Center(
                    child: Container(
                      width: w.clamp(4, 20),
                      height: w.clamp(4, 20),
                      decoration: BoxDecoration(
                        color: widget.selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
            widget.onWidthChanged(_width);
            Navigator.pop(context);
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
