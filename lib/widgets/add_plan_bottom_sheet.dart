import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/category_model.dart';
import '../models/task_model.dart';
import '../utils/add_category_dialog.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandleBar(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleInput(isDark),
                  _buildDescriptionInput(isDark, theme),
                  const SizedBox(height: 15),
                  _buildTopActions(isDark),
                  const SizedBox(height: 25),
                  Text(t('add_roadmap'), style: _sectionStyle(isDark)),
                  const SizedBox(height: 12),
                  _buildPhaseList(),
                  const SizedBox(height: 12),
                  _buildAddPhaseButton(isDark),
                ],
              ),
            ),
          ),
          _buildSaveButton(isDark, theme),
        ],
      ),
    );
  }

  Widget _buildHandleBar(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? Colors.white24 : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  TextStyle _sectionStyle(bool isDark) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: isDark ? Colors.white38 : Colors.grey,
    letterSpacing: 1.2,
  );

  Widget _buildTitleInput(bool isDark) {
    return TextField(
      controller: _titleController,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: t('add_title_hint'),
        hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400]),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildDescriptionInput(bool isDark, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: TextField(
        controller: _descriptionController,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 14,
        ),
        maxLength: 100,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: t('add_note_hint'),
          hintStyle: TextStyle(
            color: isDark ? Colors.white24 : Colors.grey[400],
            fontSize: 13,
          ),
          border: InputBorder.none,
          counterText: "",
          icon: Icon(
            Icons.edit_note_rounded,
            color: isDark ? Colors.white24 : Colors.grey[400],
            size: 20,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildTopActions(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: InfoChip(
            key: _categoryKey,
            icon: _category?.icon ?? Icons.folder_open,
            label: _category != null ? t(_category!.name) : t('add_category'),
            color: isDark
                ? Colors.purple.withOpacity(0.15)
                : Colors.purple[50]!,
            iconColor: isDark ? Colors.purple[200]! : Colors.purple,
            locale: widget.locale,
            onTap: () async {
              final selected = await CategoryPickerService.show(
                context: context,
                anchorKey: _categoryKey,
                locale: widget.locale,
              );

              if (selected?.id == 'add_new_id') {
                final newCat = await showAddCategoryDialog(
                  context,
                  widget.locale,
                  t,
                );
                if (newCat != null) setState(() => _category = newCat);
              } else if (selected != null) {
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
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dateChip(
            _endDate,
            t('add_end'),
            Colors.blue,
            () => _pickDate(false),
            isDark,
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
    bool isDark,
  ) {
    return SizedBox(
      height: 40,
      child: InfoChip(
        icon: label == t('add_start')
            ? Icons.calendar_today_rounded
            : Icons.arrow_forward_rounded,
        label: date == null ? label : "${date.day}/${date.month}",
        color: isDark ? color.withOpacity(0.15) : color[50]!,
        iconColor: isDark ? color[200]! : color[700]!,
        locale: widget.locale,
        onTap: onTap,
      ),
    );
  }

  Widget _buildPhaseList() {
    return Column(
      children: _phases.asMap().entries.map<Widget>((entry) {
        int index = entry.key;
        PhaseModel phase = entry.value;

        return PhaseItem(
          key: ValueKey(phase),
          index: index,
          phase: phase,
          locale: widget.locale,
          onTitleChanged: (newTitle) => phase.title = newTitle,
          onAddTask: (taskTitle) =>
              setState(() => phase.tasks.add(TaskModel(title: taskTitle))),
          onDeletePhase: () {
            if (_phases.length > 1) {
              _confirmDeletePhase(context, phase, index);
            } else {
              AlertUtils.show(context, t('msg_min_phase_error'), isError: true);
            }
          },
        );
      }).toList(),
    );
  }

  void _confirmDeletePhase(BuildContext context, PhaseModel phase, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(t('confirm_delete_content')),
          content: Text("${t('confirm_delete_title')} '${phase.title}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t('btn_cancel')),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _phases.removeAt(index);
                });
                Navigator.of(ctx).pop();

                AlertUtils.show(context, t('msg_success_delete'));
              },
              child: Text(
                t('btn_delete'),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddPhaseButton(bool isDark) {
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
        side: BorderSide(
          color: isDark ? Colors.purple.withOpacity(0.3) : Colors.purple[100]!,
        ),
        foregroundColor: isDark ? Colors.purple[200] : Colors.purple,
      ),
    );
  }

  Widget _buildSaveButton(bool isDark, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: ElevatedButton(
        onPressed: _savePlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? theme.colorScheme.primary : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          t('add_btn_create'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          if (isStart)
            _startDate = date;
          else
            _endDate = date;
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
    if (_startDate!.isAfter(finalEndDate)) {
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
}
