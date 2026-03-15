import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../data/language_data.dart';
import '../utils/alert.dart';
import 'about_screen.dart';
import '../widgets/plan_card.dart';
import '../widgets/filter_chip.dart';
import '../widgets/app_drawer.dart';
import '../widgets/add_plan_bottom_sheet.dart';
import '../data/plan_data.dart';
import '../data/category_data.dart';
import '../models/category_model.dart';
import '../models/plan_model.dart';
import 'plan_detail_screen.dart';
import '../utils/plan_group.dart';

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
  String _locale = 'vi';
  String t(String key) {
    return localizedText[_locale]?[key] ?? key;
  }

  bool _isSettingsExpanded = false;
  int _selectedIndex = 0;
  late CategoryModel? _selectedCategory;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = null;
  }

  Widget _buildMainContent() {
    final allFiltered = samplePlans.where((plan) {
      final matchesCategory =
          _selectedCategory == null ||
          plan.category?.id == _selectedCategory!.id;
      final matchesSearch =
          _searchQuery.isEmpty ||
          plan.title.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    if (allFiltered.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text(
            t('no_plan'),
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      );
    }

    final activePlans = allFiltered.where((p) => !p.isDone).toList();
    final completedPlans = allFiltered.where((p) => p.isDone).toList();
    final groupedActive = groupPlansByTime(activePlans);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...groupedActive.entries.map((entry) {
          if (entry.value.isEmpty) return const SizedBox.shrink();
          return _buildSection(entry.key, entry.value);
        }),
        if (completedPlans.isNotEmpty)
          _buildSection("Đã hoàn thành", completedPlans, isDoneSection: true),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSection(
    String title,
    List<PlanModel> plans, {
    bool isDoneSection = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: isDoneSection ? Colors.green[700] : Colors.grey[600],
            ),
          ),
        ),
        ...plans.map((plan) => _buildSlidableItem(plan)),
      ],
    );
  }

  Widget _buildSlidableItem(PlanModel plan) {
    return Slidable(
      key: ObjectKey(plan),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.45,
        children: [
          CustomSlidableAction(
            onPressed: (context) {
              setState(() {
                for (var phase in plan.phases) {
                  for (var task in phase.tasks) {
                    task.isDone = true;
                  }
                }
              });
              AlertUtils.show(
                context,
                "Chúc mừng! Bạn đã hoàn thành toàn bộ lộ trình '${plan.title}'",
              );
            },
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            child: _buildActionButton(
              icon: Icons.check_circle_outline_rounded,
              color: Colors.green,
              label: '',
            ),
          ),

          CustomSlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(t('confirm_delete')),
                  content: Text("${t('delete_msg')} '${plan.title}'?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(t('btn_cancel')),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => samplePlans.remove(plan));
                        Navigator.pop(ctx);
                        AlertUtils.show(context, t('delete_success'));
                      },
                      child: Text(
                        t('btn_delete'),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            child: _buildActionButton(
              icon: Icons.delete_outline_rounded,
              color: Colors.redAccent,
              label: '',
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlanDetailScreen(plan: plan, locale: _locale),
            ),
          );
          setState(() {});
        },
        child: planCard(plan),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Icon(icon, color: color, size: 26)),
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
        locale: _locale,
        onNavigate: (value) {
          if (value == 'settings') {
            setState(() => _isSettingsExpanded = !_isSettingsExpanded);
          } else if (value == 'change_lang') {
            setState(() {
              _locale = (_locale == 'vi') ? 'en' : 'vi';
            });
          } else {
            Navigator.pop(context);
            if (value == 'about') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AboutScreen(locale: _locale)),
              );
            }
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildCategoryFilter(),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildMainContent(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        _isSearching
            ? Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: t('search_hint'),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => setState(() => _isSearching = true),
              ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedCategory = null),
            child: filterChip(
              t('all_cat'),
              isSelected: _selectedCategory == null,
            ),
          ),
          const SizedBox(width: 8),
          ...sampleCategories.map((category) {
            final isSelected = _selectedCategory?.id == category.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: filterChip(category.name, isSelected: isSelected),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) async {
        if (index == 1) {
          final newPlan = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) => const AddPlanBottomSheet(),
          );

          setState(() {
            if (newPlan != null) {
              samplePlans.add(newPlan);
              AlertUtils.show(context, "Đã tạo kế hoạch mới thành công!");
            }
          });
          return;
        }
        setState(() => _selectedIndex = index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: t('title'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 40, color: Colors.purple),
          label: t('add'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: t('dashboard'),
        ),
      ],
    );
  }
}
