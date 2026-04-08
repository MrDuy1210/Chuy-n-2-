import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // App Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.brush,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // App Name
            const Text(
              'Vẽ Tranh',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Phiên bản 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Ứng dụng vẽ tranh đơn giản cho phép bạn sáng tạo nghệ thuật '
                'ngay trên thiết bị di động. Với các công cụ vẽ đa dạng, '
                'bảng màu phong phú và khả năng lưu trữ, bạn có thể thoả sức sáng tạo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tính năng chính',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.edit,
                    'Vẽ tự do',
                    'Vẽ tự do trên canvas với nhiều công cụ',
                  ),
                  _buildFeatureItem(
                    Icons.palette,
                    'Chọn màu sắc',
                    'Bảng màu đa dạng với 20+ màu sắc',
                  ),
                  _buildFeatureItem(
                    Icons.line_weight,
                    'Tuỳ chỉnh nét vẽ',
                    'Thay đổi độ dày nét vẽ linh hoạt',
                  ),
                  _buildFeatureItem(
                    Icons.auto_fix_high,
                    'Công cụ tẩy',
                    'Tẩy xoá dễ dàng các chi tiết',
                  ),
                  _buildFeatureItem(
                    Icons.undo,
                    'Hoàn tác / Làm lại',
                    'Hỗ trợ hoàn tác và làm lại thao tác',
                  ),
                  _buildFeatureItem(
                    Icons.save,
                    'Lưu tranh',
                    'Lưu bức tranh vào thư viện',
                  ),
                  _buildFeatureItem(
                    Icons.photo_library,
                    'Thư viện tranh',
                    'Quản lý các bức tranh đã vẽ',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Developer Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Thông tin đồ án',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Đề tài', 'Ứng dụng vẽ tranh đơn giản'),
                  _buildInfoRow('Môn học', 'Phát triển ứng dụng di động'),
                  _buildInfoRow('Công nghệ', 'Flutter / Dart'),
                  _buildInfoRow('Năm', '2026'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Footer
            Text(
              'Được phát triển bằng Flutter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
