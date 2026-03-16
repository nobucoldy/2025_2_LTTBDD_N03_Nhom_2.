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
        title: Text(t('about_title')),
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
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 80,
                    color: isDark ? Colors.purple[300] : Colors.purple,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t('app_name'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${t('version')} 1.0.0',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 40),

            Text(
              t('team_members'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.purple[200] : Colors.purple,
              ),
            ),
            const SizedBox(height: 10),

            _buildMemberTile('Nguyễn Quế Bắc', '23010574', 'CNTT6-K17', isDark),
            _buildMemberTile(
              'Hoàng Tuấn Kiệt',
              '23010517',
              'CNTT6-K17',
              isDark,
            ),

            const SizedBox(height: 30),

            Text(
              t('tech_stack'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Card(
              elevation: 0,
              color: isDark ? theme.colorScheme.surface : Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey[200]!,
                ),
              ),
              margin: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  t('tech_list'),
                  style: TextStyle(
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(String name, String mssv, String role, bool isDark) {
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
        'MSSV: $mssv - $role',
        style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
      ),
    );
  }
}
