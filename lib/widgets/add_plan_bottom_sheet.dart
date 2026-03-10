import 'package:flutter/material.dart';
import '../widgets/category_box.dart';
import '../widgets/quick_action.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../data/category_data.dart';
import '../models/category_model.dart';
import 'custom_date_picker.dart';
import '../models/task_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  int? _editingPhaseIndex;
  final TextEditingController _taskController = TextEditingController();
  int? _editingPhaseTitleIndex;
  final TextEditingController _phaseTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tên kế hoạch của bạn...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 15),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryBox(
                            category: _category,
                            onTap: () => _showCategoryPicker(context),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickActionButton(
                            icon: Icons.calendar_today_rounded,
                            label: _startDate == null
                                ? 'Bắt đầu'
                                : '${_startDate!.day}/${_startDate!.month}',
                            onTap: () => _pickDate(context, true),
                          ),
                          const SizedBox(width: 8),
                          _buildQuickActionButton(
                            icon: Icons.arrow_forward_rounded,
                            label: _endDate == null
                                ? 'Kết thúc'
                                : '${_endDate!.day}/${_endDate!.month}',
                            onTap: () => _pickDate(context, false),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    const Text(
                      "LỘ TRÌNH THỰC HIỆN",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPhases(),
                  ],
                ),
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.blueGrey[700]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhases() {
    return Column(
      children: [
        ..._phases.asMap().entries.map((entry) {
          final index = entry.key;
          final phase = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.purple[100],
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _editingPhaseTitleIndex == index
                          ? TextField(
                              controller: _phaseTitleController,
                              autofocus: true,
                              onSubmitted: _savePhaseTitle,
                              onTapOutside: (_) =>
                                  _savePhaseTitle(_phaseTitleController.text),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _editingPhaseTitleIndex = index;
                                  _phaseTitleController.text = phase.title;
                                });
                              },
                              child: Text(
                                phase.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                ...phase.tasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_editingPhaseIndex == index)
                  TextField(
                    controller: _taskController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Việc cần làm...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 28),
                    ),
                    onSubmitted: (val) => _addTask(index, val),
                    onTapOutside: (_) => _addTask(index, _taskController.text),
                  )
                else
                  TextButton.icon(
                    onPressed: () => setState(() => _editingPhaseIndex = index),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text("Thêm nhiệm vụ"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: _addPhase,
          icon: const Icon(Icons.add_road_rounded),
          label: const Text('Thêm giai đoạn mới'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: Colors.purple[100]!),
            foregroundColor: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      color: Colors.white,
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

  void _addPhase() {
    setState(() {
      _phases.add(
        PhaseModel(title: 'Giai đoạn ${_phases.length + 1}', tasks: []),
      );
      _editingPhaseTitleIndex = _phases.length - 1;
      _phaseTitleController.text = _phases.last.title;
    });
  }

  void _addTask(int phaseIndex, String title) {
    if (title.trim().isEmpty) {
      setState(() => _editingPhaseIndex = null);
      return;
    }
    setState(() {
      _phases[phaseIndex].tasks.add(TaskModel(title: title.trim()));
      _editingPhaseIndex = null;
      _taskController.clear();
    });
  }

  void _savePhaseTitle(String value) {
    if (value.trim().isNotEmpty && _editingPhaseTitleIndex != null) {
      setState(() => _phases[_editingPhaseTitleIndex!].title = value.trim());
    }
    setState(() => _editingPhaseTitleIndex = null);
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    DateTime initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            CustomDatePicker(
              initialDate: initial,
              onDateSelected: (date) {
                setState(() {
                  if (isStart)
                    _startDate = date;
                  else
                    _endDate = date;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, 45), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final CategoryModel? selected = await showMenu<CategoryModel?>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: [
        _buildPopupItem(
          null,
          'Không thể loại',
          Icons.folder_off_rounded,
          Colors.grey,
        ),
        ...sampleCategories.map(
          (cat) => _buildPopupItem(cat, cat.name, cat.icon, Colors.purple),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => Future.delayed(
            Duration.zero,
            () => _showAddCategoryDialog(context),
          ),
          child: const Row(
            children: [
              Icon(Icons.add, color: Colors.purple),
              SizedBox(width: 8),
              Text('Thêm mới'),
            ],
          ),
        ),
      ],
    );
    if (selected != _category) setState(() => _category = selected);
  }

  PopupMenuItem<CategoryModel?> _buildPopupItem(
    CategoryModel? value,
    String text,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem<CategoryModel?>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm thể loại'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(
                  () => sampleCategories.add(
                    CategoryModel(
                      id: DateTime.now().toString(),
                      name: controller.text.trim(),
                      icon: Icons.label_outline,
                    ),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _savePlan() {
    if (_titleController.text.trim().isEmpty) {
      showToast('Vui lòng nhập tên kế hoạch');
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

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
