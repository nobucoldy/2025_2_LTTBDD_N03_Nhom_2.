import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../utils/alert.dart';
import '../utils/category_picker.dart';
import '../widgets/info_chip.dart';
import '../widgets/custom_date_picker.dart';
import '../data/language_data.dart';

class PlanDetailScreen extends StatefulWidget {
  final PlanModel plan;
  final String locale;

  const PlanDetailScreen({super.key, required this.plan, required this.locale});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  late TextEditingController _titleController;
  final GlobalKey _categoryKey = GlobalKey();

  String t(String key) => localizedText[widget.locale]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: t(widget.plan.title));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _pickDate(bool isStart) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandleBar(isDark),
            CustomDatePicker(
              initialDate:
                  (isStart ? widget.plan.startDate : widget.plan.endDate) ??
                  DateTime.now(),
              referenceDate: widget.plan.startDate,
              onDateSelected: (date) {
                DateTime currentStart = isStart
                    ? date
                    : (widget.plan.startDate ?? DateTime.now());
                DateTime currentEnd = isStart
                    ? (widget.plan.endDate ?? DateTime.now())
                    : date;

                if (currentStart.isAfter(currentEnd)) {
                  AlertUtils.show(
                    context,
                    t('detail_error_date'),
                    isError: true,
                  );
                  return;
                }

                setState(() {
                  if (isStart)
                    widget.plan.startDate = date;
                  else
                    widget.plan.endDate = date;
                });
              },
              locale: widget.locale,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.white24 : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final plan = widget.plan;
    final progress = plan.progress;
    final isDone = plan.isDone;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
        title: TextField(
          controller: _titleController,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: t('detail_hint_title'),
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            border: InputBorder.none,
          ),
          onChanged: (val) => plan.title = val,
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildDescriptionField(plan, theme),
                  const SizedBox(height: 16),
                  _buildInfoChips(plan, isDark),
                  const Divider(height: 40),
                  _buildProgressSection(isDone, progress, isDark),
                  const Divider(height: 40),
                  Text(
                    t('detail_roadmap'),
                    style: _sectionStyle(isDark ? Colors.white54 : Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ...plan.phases.map(
                    (phase) => _buildPhaseDetail(phase, theme),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(PlanModel plan, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[100]!),
      ),
      child: TextFormField(
        initialValue: plan.description,
        maxLength: 150,
        maxLines: null,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.grey[700],
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: t('detail_hint_note'),
          hintStyle: TextStyle(
            color: isDark ? Colors.white24 : Colors.grey[400],
            fontSize: 13,
          ),
          border: InputBorder.none,
          counterText: "",
          icon: Icon(
            Icons.notes_rounded,
            color: isDark ? Colors.white24 : Colors.grey[400],
            size: 18,
          ),
        ),
        onChanged: (val) => plan.description = val,
      ),
    );
  }

  Widget _buildInfoChips(PlanModel plan, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: InfoChip(
            key: _categoryKey,
            icon: plan.category?.icon ?? Icons.folder_open,
            label: plan.category != null
                ? t(plan.category!.name)
                : t('all_cat'),
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
              if (selected != null) {
                setState(() {
                  widget.plan.category = selected;
                });
              }
            },
          ),
        ),

        const SizedBox(width: 8),
        Expanded(
          child: _dateChip(
            plan.startDate,
            t('detail_start'),
            Colors.orange,
            () => _pickDate(true),
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dateChip(
            plan.endDate,
            t('detail_end'),
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
    String placeholder,
    MaterialColor color,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InfoChip(
      icon: placeholder == t('detail_start')
          ? Icons.calendar_today_rounded
          : Icons.arrow_forward_rounded,
      label: date == null ? placeholder : '${date.day}/${date.month}',
      color: isDark ? color.withOpacity(0.15) : color[50]!,
      iconColor: isDark ? color[200]! : color[700]!,
      locale: widget.locale,
      onTap: onTap,
    );
  }

  Widget _buildProgressSection(bool isDone, double progress, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              isDone ? t('detail_completed_title') : t('detail_progress'),
              style: _sectionStyle(
                isDone ? Colors.green : (isDark ? Colors.white54 : Colors.grey),
              ),
            ),
            const Spacer(),
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDone
                    ? Colors.green
                    : (isDark ? Colors.white70 : Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isDone ? Colors.green : Colors.purple,
            ),
          ),
        ),
        if (isDone) _buildSuccessMsg(),
      ],
    );
  }

  Widget _buildSuccessMsg() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(
            t('detail_success_msg'),
            style: const TextStyle(color: Colors.green, fontSize: 13),
          ),
        ],
      ),
    );
  }

  TextStyle _sectionStyle(Color color) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: color,
    letterSpacing: 1.2,
  );
  Widget _buildPhaseDetail(PhaseModel phase, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: t(phase.title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            onChanged: (val) => phase.title = val,
          ),
          Divider(
            height: 20,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          Column(
            children: List.generate(phase.tasks.length, (index) {
              final task = phase.tasks[index];
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: task.isDone,
                activeColor: Colors.purple,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  t(task.title),
                  style: TextStyle(
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                    color: task.isDone
                        ? (isDark ? Colors.white30 : Colors.grey)
                        : (isDark ? Colors.white70 : Colors.black),
                  ),
                ),
                onChanged: (val) {
                  setState(() => task.isDone = val!);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
