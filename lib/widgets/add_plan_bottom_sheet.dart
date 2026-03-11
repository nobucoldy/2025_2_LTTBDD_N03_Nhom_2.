import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/category_model.dart';
import '../models/task_model.dart';
import '../widgets/info_chip.dart';
import '../widgets/phase_item.dart';
import '../utils/category_picker.dart';
import 'custom_date_picker.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  CategoryModel? _category;
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _titleController = TextEditingController();
  final List<PhaseModel> _phases = [
    PhaseModel(title: 'Giai đoạn 1', tasks: []),
  ];

  final GlobalKey _categoryKey = GlobalKey();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
                  const SizedBox(height: 15),
                  _buildTopActions(),
                  const SizedBox(height: 25),
                  const Text(
                    "LỘ TRÌNH THỰC HIỆN",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
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

  Widget _buildTitleInput() {
    return TextField(
      controller: _titleController,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: 'Tên kế hoạch của bạn...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildTopActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        InfoChip(
          key: _categoryKey,
          icon: _category?.icon ?? Icons.folder_open,
          label: _category?.name ?? 'Thể loại',
          color: Colors.purple[50]!,
          iconColor: Colors.purple,
          onTap: () async {
            final selected = await CategoryPickerService.show(
              context: context,
              anchorKey: _categoryKey,
            );
            if (selected != null) setState(() => _category = selected);
          },
        ),
        InfoChip(
          icon: Icons.calendar_today_rounded,
          label: _startDate == null
              ? 'Bắt đầu'
              : "${_startDate!.day}/${_startDate!.month}",
          color: Colors.orange[50]!,
          iconColor: Colors.orange[700]!,
          onTap: () => _pickDate(true),
        ),
        InfoChip(
          icon: Icons.arrow_forward_rounded,
          label: _endDate == null
              ? 'Kết thúc'
              : "${_endDate!.day}/${_endDate!.month}",
          color: Colors.blue[50]!,
          iconColor: Colors.blue[700]!,
          onTap: () => _pickDate(false),
        ),
      ],
    );
  }

  Widget _buildPhaseList() {
    return Column(
      children: _phases.asMap().entries.map<Widget>((entry) {
        return PhaseItem(
          key: ValueKey(entry.value),
          index: entry.key,
          phase: entry.value,
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
            PhaseModel(title: 'Giai đoạn ${_phases.length + 1}', tasks: []),
          );
        });
      },
      icon: const Icon(Icons.add_road_rounded),
      label: const Text('Thêm giai đoạn mới'),
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
        child: const Text(
          'Tạo kế hoạch ngay',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
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
            const SizedBox(height: 12),
            CustomDatePicker(
              initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
              onDateSelected: (date) =>
                  setState(() => isStart ? _startDate = date : _endDate = date),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _savePlan() {
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Vui lòng nhập tên kế hoạch",
        gravity: ToastGravity.TOP,
      );
      return;
    }
    final newPlan = PlanModel(
      title: _titleController.text.trim(),
      category: _category,
      startDate: _startDate ?? DateTime.now(),
      endDate: _endDate ?? DateTime.now(),
      phases: List.from(_phases),
    );
    Navigator.pop(context, newPlan);
  }
}
