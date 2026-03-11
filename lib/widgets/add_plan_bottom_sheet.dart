import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/category_data.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/category_model.dart';
import '../models/task_model.dart';
import '../widgets/info_chip.dart';
import '../widgets/phase_item.dart';
import '../utils/category_picker.dart';
import '../utils/date_picker.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  CategoryModel? _category;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;

  final TextEditingController _titleController = TextEditingController();
  final List<PhaseModel> _phases = [
    PhaseModel(title: 'Giai đoạn 1', tasks: []),
  ];

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          height: 40,
          child: InfoChip(
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
              if (selected == null) {
                setState(() => _category = null);
                return;
              }
              if (selected.id == 'add_new_id') {
                _showAddCategoryDialog();
              } else {
                setState(() => _category = selected);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          height: 40,
          child: InfoChip(
            icon: Icons.calendar_today_rounded,
            label: _startDate == null
                ? 'Bắt đầu'
                : "${_startDate!.day}/${_startDate!.month}",
            color: Colors.orange[50]!,
            iconColor: Colors.orange[700]!,
            onTap: () => _pickDate(true),
          ),
        ),
        const SizedBox(width: 8),

        SizedBox(
          width: 90,
          height: 40,
          child: InfoChip(
            icon: Icons.arrow_forward_rounded,
            label: _endDate == null
                ? 'Kết thúc'
                : "${_endDate!.day}/${_endDate!.month}",
            color: Colors.blue[50]!,
            iconColor: Colors.blue[700]!,
            onTap: () => _pickDate(false),
          ),
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

    if (_endDate == null) {
      Fluttertoast.showToast(
        msg: "Vui lòng chọn ngày kết thúc",
        gravity: ToastGravity.TOP,
      );
      return;
    }

    final DateTime start = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
    );
    final DateTime end = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
    );
    if (start.isAfter(end)) {
      Fluttertoast.showToast(
        msg: "Ngày kết thúc phải sau ngày bắt đầu",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
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

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    IconData selectedIcon = Icons.folder;
    bool isPickerVisible = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Tạo thể loại mới"),
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
                  decoration: const InputDecoration(
                    hintText: "Tên thể loại...",
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
                        const Expanded(child: Text("Chọn biểu tượng đại diện")),
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
              child: const Text("Hủy"),
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
              child: const Text("Lưu lại"),
            ),
          ],
        ),
      ),
    );
  }
}
