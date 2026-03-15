import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../widgets/info_chip.dart';
import '../widgets/custom_date_picker.dart';
import '../utils/category_picker.dart';

class PlanDetailScreen extends StatefulWidget {
  final PlanModel plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  late TextEditingController _titleController;
  final GlobalKey _categoryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.plan.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _pickDate(bool isStart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            CustomDatePicker(
              initialDate:
                  (isStart ? widget.plan.startDate : widget.plan.endDate) ??
                  DateTime.now(),

              referenceDate: widget.plan.startDate,

              onDateSelected: (date) {
                setState(() {
                  if (isStart)
                    widget.plan.startDate = date;
                  else
                    widget.plan.endDate = date;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final progress = plan.progress;
    final isDone = plan.isDone;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: TextField(
          controller: _titleController,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            hintText: 'Tên kế hoạch...',
            border: InputBorder.none,
            isDense: true,
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

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: TextFormField(
                      initialValue: plan.description,
                      maxLength: 150,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (val) {
                        setState(() => plan.description = val.trim());
                        FocusScope.of(context).unfocus();
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'Thêm ghi chú...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        counterText: "",
                        icon: Icon(
                          Icons.notes_rounded,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ),
                      onChanged: (val) => plan.description = val,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 125,
                        height: 40,
                        child: InfoChip(
                          key: _categoryKey,
                          icon: plan.category?.icon ?? Icons.folder_open,
                          label: plan.category?.name ?? 'Thể loại',
                          color: Colors.purple[50]!,
                          iconColor: Colors.purple,
                          onTap: () async {
                            final selected = await CategoryPickerService.show(
                              context: context,
                              anchorKey: _categoryKey,
                            );
                            if (selected == null) {
                              setState(() => plan.category = null);
                            } else if (selected.id != 'add_new_id') {
                              setState(() => plan.category = selected);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 85,
                        height: 40,
                        child: InfoChip(
                          icon: Icons.calendar_today_rounded,
                          label: plan.startDate == null
                              ? 'Bắt đầu'
                              : '${plan.startDate!.day}/${plan.startDate!.month}',
                          color: Colors.orange[50]!,
                          iconColor: Colors.orange[700]!,
                          onTap: () => _pickDate(true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 85,
                        height: 40,
                        child: InfoChip(
                          icon: Icons.arrow_forward_rounded,
                          label: plan.endDate == null
                              ? 'Kết thúc'
                              : '${plan.endDate!.day}/${plan.endDate!.month}',
                          color: Colors.blue[50]!,
                          iconColor: Colors.blue[700]!,
                          onTap: () => _pickDate(false),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 40),

                  Row(
                    children: [
                      Text(
                        isDone ? "KẾ HOẠCH HOÀN THÀNH" : "TIẾN ĐỘ",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isDone ? Colors.green : Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDone ? Colors.green : Colors.black,
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
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDone ? Colors.green : Colors.purple,
                      ),
                    ),
                  ),
                  if (isDone)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Tuyệt vời! Bạn đã hoàn thành mọi thứ.",
                            style: TextStyle(color: Colors.green, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                  const Divider(height: 40),

                  const Text(
                    "LỘ TRÌNH CHI TIẾT",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...plan.phases.map((phase) => _buildPhaseDetail(phase)),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseDetail(PhaseModel phase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: phase.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            onChanged: (val) => phase.title = val,
          ),
          const Divider(height: 20),
          ...phase.tasks.map(
            (task) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: task.isDone,
              title: TextFormField(
                initialValue: task.title,
                style: TextStyle(
                  fontSize: 14,
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: task.isDone ? Colors.grey : Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (val) => task.title = val,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (val) => setState(() => task.isDone = val!),
            ),
          ),
        ],
      ),
    );
  }
}
