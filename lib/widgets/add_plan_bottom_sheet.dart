import 'package:flutter/material.dart';
import '../widgets/category_box.dart';
import '../widgets/quick_action.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../data/category_data.dart';
import '../models/category_model.dart';
import 'custom_date_picker.dart';
import '../models/task_model.dart';

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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập kế hoạch mới tại đây',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryBox(
                          category: _category,
                          onTap: () => _showCategoryPicker(context),
                        ),
                        const SizedBox(width: 6),
                        QuickAction(
                          icon: Icons.calendar_today_outlined,
                          text: _startDate == null
                              ? 'Bắt đầu'
                              : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          onTap: () => _pickDate(context, true),
                        ),
                        const SizedBox(width: 6),
                        QuickAction(
                          icon: Icons.calendar_today_outlined,
                          text: _endDate == null
                              ? 'Kết thúc'
                              : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          onTap: () => _pickDate(context, false),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildPhases(),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _savePlan,
                child: const Text(
                  'Lưu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhases() {
    return Column(
      children: [
        ..._phases.asMap().entries.map((entry) {
          final index = entry.key;
          final phase = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_editingPhaseTitleIndex == index)
                  TextField(
                    controller: _phaseTitleController,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Tên giai đoạn...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        if (value.trim().isNotEmpty) {
                          phase.title = value.trim();
                        }
                        _editingPhaseTitleIndex = null;
                      });
                    },
                  )
                else
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _editingPhaseTitleIndex = index;
                        _phaseTitleController.text = phase.title;
                      });
                    },
                    child: Text(
                      phase.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(height: 6),

                ...phase.tasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(task.title, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),

                if (_editingPhaseIndex == index)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TextField(
                      controller: _taskController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Nhập nhiệm vụ...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isEmpty) {
                          setState(() => _editingPhaseIndex = null);
                          return;
                        }

                        setState(() {
                          phase.tasks.add(TaskModel(title: value.trim()));
                          _taskController.clear();
                          _editingPhaseIndex = null;
                        });
                      },
                    ),
                  ),

                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _editingPhaseIndex = index;
                      _taskController.clear();
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Thêm nhiệm vụ'),
                ),
              ],
            ),
          );
        }),

        TextButton.icon(
          onPressed: _addPhase,
          icon: const Icon(Icons.add),
          label: const Text(
            'Thêm giai đoạn',
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ],
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

  void _addTask(int phaseIndex) {
    setState(() {
      _phases[phaseIndex].tasks.add(TaskModel(title: 'Nhiệm vụ mới'));
    });
  }

  void _savePlan() {
    if (_titleController.text.trim().isEmpty) return;

    final newPlan = PlanModel(
      title: _titleController.text.trim(),
      category: _category,
      startDate: _startDate,
      endDate: _endDate,
      phases: _phases,
    );

    Navigator.pop(context, newPlan);
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    DateTime initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return CustomDatePicker(
          initialDate: initial,
          onDateSelected: (date) {
            setState(() {
              if (isStart) {
                _startDate = date;
              } else {
                _endDate = date;
              }
            });
          },
        );
      },
    );
  }

  void _showCategoryPicker(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, -10), ancestor: overlay),
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
      useRootNavigator: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 220),
      items: [
        _buildPopupItem(
          null,
          'không có thể loại',
          Icons.folder_open,
          Colors.blueGrey,
        ),
        ...sampleCategories.map((cat) {
          return _buildPopupItem(cat, cat.name, cat.icon, Colors.purple);
        }),

        const PopupMenuDivider(height: 1),

        PopupMenuItem(
          height: 38,
          onTap: () => Future.delayed(
            Duration.zero,
            () => _showAddCategoryDialog(context),
          ),
          child: Row(
            children: const [
              Icon(Icons.add, size: 18, color: Colors.purple),
              SizedBox(width: 10),
              Text(
                'Thêm thể loại',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (selected != _category) {
      setState(() => _category = selected);
    }
  }

  PopupMenuItem<CategoryModel?> _buildPopupItem(
    CategoryModel? value,
    String text,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem<CategoryModel?>(
      value: value,
      height: 38,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Thêm thể loại'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Tên thể loại...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                setState(() {
                  sampleCategories.add(
                    CategoryModel(
                      id: DateTime.now().toString(),
                      name: controller.text.trim(),
                      icon: Icons.label_outline,
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }
}
