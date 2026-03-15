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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(color: Colors.purple),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              locale == 'vi' ? 'Menu' : 'Menu',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(locale == 'vi' ? 'Giới thiệu' : 'About'),
            onTap: () => onNavigate('about'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(locale == 'vi' ? 'Cài đặt' : 'Settings'),
            trailing: Icon(
              isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => onNavigate('settings'),
          ),

          if (isSettingsExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.language, size: 20),
                    title: Text(
                      locale == 'vi' ? "Tiếng Việt" : "English",
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: locale == 'en',
                    activeThumbColor: Colors.purple,
                    onChanged: (bool value) {
                      onNavigate('change_lang');
                    },
                  ),
                  SwitchListTile(
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: 20,
                    ),
                    title: Text(
                      locale == 'vi' ? 'Chế độ tối' : 'Dark Mode',
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: isDarkMode,
                    activeThumbColor: Colors.purple,
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
