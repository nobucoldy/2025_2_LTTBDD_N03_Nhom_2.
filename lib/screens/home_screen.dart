import 'package:flutter/material.dart';
import 'about_screen.dart';
import '../widgets/plan_card.dart';
import '../widgets/filter_chip.dart';
import '../widgets/app_drawer.dart';
import '../widgets/add_plan_bottom_sheet.dart';
import '../data/plan_data.dart';
import '../data/category_data.dart';
import '../models/category_model.dart';

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
  bool _isSettingsExpanded = false;
  int _selectedIndex = 0;
  late CategoryModel? _selectedCategory;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedCategory = sampleCategories.first;
  }

  Widget _buildMainContent() {
    final filteredPlans = samplePlans.where((plan) {
      if (_selectedCategory == null) return true;
      return plan.category.id == _selectedCategory!.id;
    }).toList();

    if (filteredPlans.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Chưa có kế hoạch cho thể loại này',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: filteredPlans.map((plan) => planCard(plan)).toList(),
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
          Navigator.pop(context);

          if (value == 'about') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
            return;
          }

          if (value == 'settings') {
            setState(() {
              _isSettingsExpanded = !_isSettingsExpanded;
            });
          }
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// Top bar
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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                    child: filterChip(
                      'Tất cả',
                      isSelected: _selectedCategory == null,
                    ),
                  ),
                  const SizedBox(width: 8),

                  ...sampleCategories.map((category) {
                    final isSelected = _selectedCategory?.id == category.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: filterChip(
                          category.name,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// Plan list
            Expanded(child: SingleChildScrollView(child: _buildMainContent())),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == 1) {
            final newPlan = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const AddPlanBottomSheet(),
            );

            if (newPlan != null) {
              setState(() {
                samplePlans.add(newPlan);
              });
            }
            return;
          }

          setState(() {
            _selectedIndex = index;
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
