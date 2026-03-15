import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/category_data.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/category_model.dart';
import '../models/task_model.dart';
import '../utils/alert.dart';
import '../widgets/info_chip.dart';
import '../widgets/phase_item.dart';
import '../utils/category_picker.dart';
import '../utils/date_picker.dart';
import '../data/language_data.dart';

class AddPlanBottomSheet extends StatefulWidget {
  final String locale;

  const AddPlanBottomSheet({super.key, required this.locale});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  CategoryModel? _category;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late List<PhaseModel> _phases;
  String t(String key) => localizedText[widget.locale]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    _phases = [PhaseModel(title: '${t('add_phase_name')} 1', tasks: [])];
  }

  final GlobalKey _categoryKey = GlobalKey();
  final List<IconData> _quickIcons = [
    Icons.folder,
    Icons.work,
    Icons.school,
    Icons.star,
    Icons.favorite,
    Icons.fitness_center,
    Icons.directions_run,
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.auto_stories,
    Icons.brush,
    Icons.camera_alt,
    Icons.computer,
    Icons.movie,
    Icons.flight,
    Icons.directions_car,
    Icons.home,
    Icons.payments,
    Icons.self_improvement,
    Icons.rocket_launch,
    Icons.event_note,
    Icons.build,
    Icons.lightbulb,
    Icons.pets,
  ];
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandleBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleInput(),
                  _buildDescriptionInput(),
                  const SizedBox(height: 15),
                  _buildTopActions(),
                  const SizedBox(height: 25),
                  Text(t('add_roadmap'), style: _sectionStyle()),
                  const SizedBox(height: 12),
                  _buildPhaseList(),
                  _buildAddPhaseButton(),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  TextStyle _sectionStyle() => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: Colors.grey,
    letterSpacing: 1.2,
  );
  Widget _buildTitleInput() {
    return TextField(
      controller: _titleController,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: t('add_title_hint'),
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLength: 100,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: t('add_note_hint'),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          border: InputBorder.none,
          counterText: "",
          icon: Icon(
            Icons.edit_note_rounded,
            color: Colors.grey[400],
            size: 20,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildTopActions() {
    return Row(
      children: [
        Expanded(
          child: InfoChip(
            key: _categoryKey,
            icon: _category?.icon ?? Icons.folder_open,
            label: _category != null ? t(_category!.name) : t('add_category'),
            color: Colors.purple[50]!,
            iconColor: Colors.purple,
            locale: widget.locale,
            onTap: () async {
              final selected = await CategoryPickerService.show(
                context: context,
                anchorKey: _categoryKey,
                locale: widget.locale,
              );

              if (selected?.id == 'add_new_id') {
                Future.delayed(const Duration(milliseconds: 200), () {
                  _showAddCategoryDialog();
                });
              } else {
                setState(() => _category = selected);
              }
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _dateChip(
            _startDate,
            t('add_start'),
            Colors.orange,
            () => _pickDate(true),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _dateChip(
            _endDate,
            t('add_end'),
            Colors.blue,
            () => _pickDate(false),
          ),
        ),
      ],
    );
  }

  Widget _dateChip(
    DateTime? date,
    String label,
    MaterialColor color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 40,
      child: InfoChip(
        icon: label == t('add_start')
            ? Icons.calendar_today_rounded
            : Icons.arrow_forward_rounded,
        label: date == null ? label : "${date.day}/${date.month}",
        color: color[50]!,
        iconColor: color[700]!,
        locale: widget.locale,
        onTap: onTap,
      ),
    );
  }

  Widget _buildPhaseList() {
    return Column(
      children: _phases.asMap().entries.map<Widget>((entry) {
        return PhaseItem(
          key: ValueKey(entry.value),
          index: entry.key,
          phase: entry.value,
          locale: widget.locale,
          onTitleChanged: (newTitle) {
            entry.value.title = newTitle;
          },
          onAddTask: (taskTitle) {
            setState(() {
              entry.value.tasks.add(TaskModel(title: taskTitle));
            });
          },
          onDeletePhase: () {
            if (_phases.length > 1) {
              setState(() => _phases.removeAt(entry.key));
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildAddPhaseButton() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          _phases.add(
            PhaseModel(
              title: '${t('add_phase_name')} ${_phases.length + 1}',
              tasks: [],
            ),
          );
        });
      },
      icon: const Icon(Icons.add_road_rounded),
      label: Text(t('add_new_phase')),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: Colors.purple[100]!),
        foregroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: ElevatedButton(
        onPressed: _savePlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          t('add_btn_create'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _pickDate(bool isStart) {
    DatePickerService.show(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      referenceDate: _startDate,
      onDateSelected: (date) {
        setState(() {
          if (isStart) {
            _startDate = date;
          } else {
            _endDate = date;
          }
        });
      },
      locale: widget.locale,
    );
  }

  void _savePlan() {
    if (_titleController.text.trim().isEmpty) {
      AlertUtils.show(context, t('add_msg_input_name'), isError: true);
      return;
    }

    final DateTime finalEndDate = _endDate ?? (_startDate ?? DateTime.now());

    final DateTime start = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
    );
    final DateTime end = DateTime(
      finalEndDate.year,
      finalEndDate.month,
      finalEndDate.day,
    );

    if (start.isAfter(end)) {
      Fluttertoast.showToast(
        msg: t('add_msg_date_error'),
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final newPlan = PlanModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      startDate: _startDate ?? DateTime.now(),
      endDate: finalEndDate,
      phases: List.from(_phases),
    );
    Navigator.pop(context, newPlan);
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    IconData selectedIcon = Icons.folder;
    bool isPickerVisible = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(t('add_cat_dialog_title')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: t('add_cat_hint'),
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                ),
                const SizedBox(height: 20),

                InkWell(
                  onTap: () =>
                      setDialogState(() => isPickerVisible = !isPickerVisible),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(selectedIcon, color: Colors.purple),
                        const SizedBox(width: 12),
                        Expanded(child: Text(t('add_cat_pick_icon'))),
                        Icon(
                          isPickerVisible
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                if (isPickerVisible) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 150,
                    width: double.maxFinite,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemCount: _quickIcons.length,
                      itemBuilder: (context, index) {
                        final icon = _quickIcons[index];
                        final isSelected = selectedIcon == icon;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedIcon = icon;
                              isPickerVisible = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.purple : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.purple
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('btn_cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  final newCat = CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text.trim(),
                    icon: selectedIcon,
                  );
                  sampleCategories.add(newCat);
                  setState(() => _category = newCat);
                  Navigator.pop(ctx);
                }
              },
              child: Text(t('add_btn_save')),
            ),
          ],
        ),
      ),
    );
  }
}
