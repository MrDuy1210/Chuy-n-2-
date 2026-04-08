import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'drawing_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Mock data for gallery
  final List<Map<String, dynamic>> _drawings = [
    {
      'name': 'Phong cảnh mùa xuân',
      'date': '28/03/2026',
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Chân dung tự hoạ',
      'date': '25/03/2026',
      'color': const Color(0xFF2196F3),
    },
    {
      'name': 'Hoa hướng dương',
      'date': '20/03/2026',
      'color': const Color(0xFFFF9800),
    },
    {
      'name': 'Biển chiều hoàng hôn',
      'date': '15/03/2026',
      'color': const Color(0xFFE91E63),
    },
    {
      'name': 'Ngôi nhà nhỏ',
      'date': '10/03/2026',
      'color': const Color(0xFF9C27B0),
    },
    {
      'name': 'Cây cầu vồng',
      'date': '05/03/2026',
      'color': const Color(0xFF00BCD4),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện tranh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sắp xếp',
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: _drawings.isEmpty ? _buildEmptyState() : _buildGalleryGrid(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DrawingScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Vẽ mới'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Chưa có bức tranh nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy bắt đầu vẽ bức tranh đầu tiên!',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _drawings.length,
        itemBuilder: (context, index) {
          final drawing = _drawings[index];
          return _buildDrawingCard(drawing, index);
        },
      ),
    );
  }

  Widget _buildDrawingCard(Map<String, dynamic> drawing, int index) {
    return GestureDetector(
      onTap: () => _showDrawingOptions(context, drawing, index),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: (drawing['color'] as Color).withOpacity(0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: drawing['color'] as Color,
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drawing['name'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drawing['date'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDrawingOptions(
      BuildContext context, Map<String, dynamic> drawing, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  drawing['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.edit, color: AppColors.primary),
                  title: const Text('Chỉnh sửa'),
                  subtitle: const Text('Mở và chỉnh sửa bức tranh'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DrawingScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.blue),
                  title: const Text('Chia sẻ'),
                  subtitle: const Text('Chia sẻ bức tranh với bạn bè'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chức năng chia sẻ đang phát triển'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.drive_file_rename_outline, color: Colors.orange),
                  title: const Text('Đổi tên'),
                  subtitle: const Text('Thay đổi tên bức tranh'),
                  onTap: () {
                    Navigator.pop(context);
                    _showRenameDialog(context, drawing, index);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Xoá'),
                  subtitle: const Text('Xoá bức tranh vĩnh viễn'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteDialog(context, index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRenameDialog(
      BuildContext context, Map<String, dynamic> drawing, int index) {
    final controller =
        TextEditingController(text: drawing['name'] as String);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đổi tên'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tên mới',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _drawings[index]['name'] = controller.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã đổi tên thành công'),
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

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá bức tranh'),
        content: const Text(
            'Bạn có chắc chắn muốn xoá bức tranh này không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _drawings.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xoá bức tranh'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Sắp xếp theo'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sắp xếp theo tên'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Tên'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sắp xếp theo ngày tạo'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Ngày tạo'),
            ),
          ),
        ],
      ),
    );
  }
}
