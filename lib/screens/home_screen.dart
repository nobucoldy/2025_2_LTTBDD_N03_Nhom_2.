import 'package:flutter/material.dart';
import 'about_screen.dart';
import '../widgets/plan_card.dart';
import '../widgets/filter_chip.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentContent = 'home';
  bool _isSettingsExpanded = false;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildMainContent() {
    if (_currentContent == 'about') {
      return const AboutScreen();
    }

    return Column(
      children: [
        planCard('Kế hoạch 1'),
        planCard('Kế hoạch 2'),
        planCard('Kế hoạch 3'),
        planCard('Kế hoạch 4'),
        planCard('Kế hoạch 5'),
        planCard('Kế hoạch 6'),
        planCard('Kế hoạch 7'),
        planCard('Kế hoạch 8'),
        planCard('Kế hoạch 9'),
        planCard('Kế hoạch 10'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        isSettingsExpanded: _isSettingsExpanded,
        onNavigate: (value) {
          setState(() {
            if (value == 'about') _currentContent = 'about';
            if (value == 'settings') _isSettingsExpanded = !_isSettingsExpanded;
          });
          Navigator.pop(context);
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              ],
            ),
            if (_currentContent == 'home')
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children:
                      [
                            'Tất cả',
                            'Học tập',
                            'Công việc',
                            'Tài chính',
                            'Sức khỏe',
                          ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: filterChip(e),
                            ),
                          )
                          .toList(),
                ),
              ),
            const SizedBox(height: 10),
            Expanded(child: SingleChildScrollView(child: _buildMainContent())),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _currentContent = 'home';
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Kế hoạch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.purple),
            label: 'Thêm',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Của tôi'),
        ],
      ),
    );
  }
}
