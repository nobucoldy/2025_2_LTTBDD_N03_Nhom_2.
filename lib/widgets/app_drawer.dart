import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onNavigate;
  final bool isSettingsExpanded;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onNavigate,
    required this.isSettingsExpanded,
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
            child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => onNavigate('about'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            trailing: Icon(
              isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => onNavigate('settings'),
          ),
          if (isSettingsExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SwitchListTile(
                title: const Text('Chế độ tối', style: TextStyle(fontSize: 14)),
                value: isDarkMode,
                onChanged: onThemeChanged,
              ),
            ),
        ],
      ),
    );
  }
}
