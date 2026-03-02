import 'package:flutter/material.dart';
import 'about_screen.dart';

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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("Nội dung sẽ hiển thị ở đây")),
        ),
        _buildPlanItem('Kế hoạch 1'),
        _buildPlanItem('Kế hoạch 2'),
      ],
    );
  }

  Widget _buildPlanItem(String title) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Icon(Icons.delete_forever_outlined, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.purple),
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                setState(() => _currentContent = 'about');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              trailing: Icon(
                _isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: () =>
                  setState(() => _isSettingsExpanded = !_isSettingsExpanded),
            ),
            if (_isSettingsExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  leading: const Icon(Icons.palette_outlined, size: 20),
                  title: const Text(
                    'Chế độ tối',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Switch(
                    value: widget.isDarkMode,
                    activeColor: Colors.blue,
                    onChanged: (val) => widget.onThemeChanged(val),
                  ),
                ),
              ),
          ],
        ),
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
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tính năng tìm kiếm đang phát triển!"),
                        duration: Duration(milliseconds: 800),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
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
                              child: _buildCategoryChip(e),
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
