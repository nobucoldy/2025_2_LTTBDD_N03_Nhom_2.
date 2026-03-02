import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 80,
                  color: Colors.purple,
                ),
                const SizedBox(height: 10),
                const Text(
                  'APP QUẢN LÝ KẾ HOẠCH',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text('Phiên bản 1.0.0'),
              ],
            ),
          ),
          const Divider(height: 40),

          const Text(
            'Thành viên nhóm 2:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 10),

          _buildMemberTile('Nguyễn Quế Bắc', '23010574', 'CNTT6-K17'),
          _buildMemberTile('Hoàng Tuấn Kiệt', '23010517', 'CNTT6-K17'),

          const SizedBox(height: 30),

          const Text(
            'Công nghệ sử dụng:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Card(
            margin: EdgeInsets.only(top: 10),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '• Flutter Framework\n• Ngôn ngữ Dart\n• Giao diện Material 3',
                style: TextStyle(height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(String name, String mssv, String role) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.purple,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('MSSV: $mssv - $role'),
    );
  }
}
