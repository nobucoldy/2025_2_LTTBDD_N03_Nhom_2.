import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onNavigate;
  final bool isSettingsExpanded;
  final String locale;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onNavigate,
    required this.isSettingsExpanded,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: isDark ? Colors.purple[900] : Colors.purple,
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              'Menu',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            title: Text(
              locale == 'vi' ? 'Giới thiệu' : 'About',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            onTap: () => onNavigate('about'),
          ),

          ListTile(
            leading: Icon(
              Icons.settings,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            title: Text(
              locale == 'vi' ? 'Cài đặt' : 'Settings',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            trailing: Icon(
              isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
            onTap: () => onNavigate('settings'),
          ),

          if (isSettingsExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(
                      Icons.language,
                      size: 20,
                      color: isDark ? Colors.purple[200] : Colors.purple,
                    ),
                    title: Text(
                      locale == 'vi' ? "Tiếng Việt" : "English",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    value: locale == 'en',
                    activeThumbColor: Colors.purple[200],
                    activeTrackColor: Colors.purple.withOpacity(0.5),
                    onChanged: (bool value) {
                      onNavigate('change_lang');
                    },
                  ),
                  SwitchListTile(
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: 20,
                      color: isDark ? Colors.purple[200] : Colors.purple,
                    ),
                    title: Text(
                      locale == 'vi' ? 'Chế độ tối' : 'Dark Mode',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    value: isDarkMode,
                    activeThumbColor: Colors.purple[200],
                    onChanged: onThemeChanged,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
