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
import 'dashboard_screen.dart';
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
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = null;
  }

  Widget _buildMainContent() {
    final allFiltered = samplePlans.where((plan) {
      final String currentTitle = plan.title.toLowerCase();
      final bool matchesSearch =
          _searchQuery.isEmpty || currentTitle.contains(_searchQuery);
      if (!matchesSearch) return false;

      if (_showOnlyFavorites) {
        return plan.isFavorite == true;
      }

      final bool matchesCategory =
          _selectedCategory == null ||
          plan.category?.id == _selectedCategory!.id;

      return matchesCategory;
    }).toList();

    allFiltered.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return 0;
    });

    if (allFiltered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            t('no_plan'),
            style: const TextStyle(color: Colors.grey, fontSize: 15),
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
          return _buildSection(t(entry.key), entry.value);
        }),
        if (completedPlans.isNotEmpty)
          _buildSection(
            t('completed_title'),
            completedPlans,
            isDoneSection: true,
          ),
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
        extentRatio: 0.3,
        children: [
          CustomSlidableAction(
            padding: EdgeInsets.zero,
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
                "${t('msg_success_done')} '${plan.title}'",
              );
            },
            backgroundColor: Colors.transparent,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            ),
          ),

          CustomSlidableAction(
            padding: EdgeInsets.zero,
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(t('confirm_delete_content')),
                  content: Text(
                    "${t('confirm_delete_title')} '${plan.title}'?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(t('btn_cancel')),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => samplePlans.remove(plan));
                        Navigator.pop(ctx);
                        AlertUtils.show(context, t('msg_success_delete'));
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
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 24,
              ),
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
        child: planCard(plan, _locale, context, () {
          setState(() {
            plan.isFavorite = !plan.isFavorite;
          });
        }),
      ),
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
        child: _selectedIndex == 2
            ? DashboardScreen(locale: _locale)
            : Column(
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
            onTap: () => setState(() {
              _selectedCategory = null;
              _showOnlyFavorites = false;
            }),
            child: filterChip(
              t('all_cat'),
              context,
              isSelected: _selectedCategory == null && !_showOnlyFavorites,
            ),
          ),
          const SizedBox(width: 8),

          GestureDetector(
            onTap: () => setState(() {
              _showOnlyFavorites = true;
              _selectedCategory = null;
            }),
            child: filterChip(
              t('favorite_title'),
              context,
              isSelected: _showOnlyFavorites,
            ),
          ),
          const SizedBox(width: 8),

          ...sampleCategories.map((category) {
            final isSelected = _selectedCategory?.id == category.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedCategory = category;
                  _showOnlyFavorites = false;
                }),
                child: filterChip(
                  t(category.name),
                  context,
                  isSelected: isSelected,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.hintColor;

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) async {
        if (index == 1) {
          final newPlan = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) => AddPlanBottomSheet(locale: _locale),
          );

          setState(() {
            if (newPlan != null) {
              samplePlans.add(newPlan);
              AlertUtils.show(context, t('add_plan_success'));
            }
          });
          return;
        }
        setState(() => _selectedIndex = index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            _selectedIndex == 0 ? Icons.assessment : Icons.assessment_outlined,
          ),
          label: t('title'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            size: _selectedIndex == 1 ? 46 : 40,
            color: Colors.purple,
          ),
          label: t('add'),
        ),
        BottomNavigationBarItem(
          icon: Icon(_selectedIndex == 2 ? Icons.person : Icons.person_outline),
          label: t('dashboard'),
        ),
      ],
    );
  }
}
