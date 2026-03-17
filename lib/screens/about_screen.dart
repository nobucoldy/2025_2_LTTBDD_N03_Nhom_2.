import 'package:flutter/material.dart';
import '../data/language_data.dart';

class AboutScreen extends StatelessWidget {
  final String locale;

  const AboutScreen({super.key, required this.locale});

  String t(String key) {
    return localizedText[locale]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Thông tin nhóm"),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thành viên nhóm 2",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.purple[200] : Colors.purple,
              ),
            ),
            const SizedBox(height: 10),

            _buildMemberTile('Nguyễn Quế Bắc', '23010574', isDark),
            _buildMemberTile('Hoàng Tuấn Kiệt', '23010517', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(String name, String mssv, bool isDark) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isDark ? Colors.purple[300] : Colors.purple,
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        'MSV: $mssv',
        style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
      ),
    );
  }
}
