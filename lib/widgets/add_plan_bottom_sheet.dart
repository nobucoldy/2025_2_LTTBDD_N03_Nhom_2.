import 'package:flutter/material.dart';
import '../widgets/category_box.dart';
import '../widgets/quick_action.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../data/category_data.dart';
import '../models/category_model.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  CategoryModel _category = sampleCategories.first;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phaseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
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

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Giai đoạn 1:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextField(
                            controller: _phaseController,
                            decoration: const InputDecoration(
                              hintText: 'Nhập giai đoạn 1:',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 15),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: const Text('Thêm nhiệm vụ'),
                          ),
                        ],
                      ),
                    ),

                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Thêm giai đoạn',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.trim().isEmpty) return;

                  final newPlan = PlanModel(
                    title: _titleController.text.trim(),
                    category: _category,
                    startDate: _startDate,
                    endDate: _endDate,
                    phases: [
                      PhaseModel(
                        title: _phaseController.text.isEmpty
                            ? 'Giai đoạn 1'
                            : _phaseController.text,
                        tasks: [],
                      ),
                    ],
                  );

                  Navigator.pop(context, newPlan);
                },
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

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple, // màu header
              onPrimary: Colors.white, // màu chữ header
              onSurface: Colors.black, // màu chữ ngày
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple, // màu nút cancel/ok
              ),
            ),
          ),
          child: SizedBox(
            width: 300, // width nhỏ hơn
            height: 400, // height nhỏ hơn
            child: child,
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: sampleCategories.map((category) {
            return ListTile(
              leading: Icon(category.icon, color: category.color),
              title: Text(category.name),
              onTap: () {
                setState(() {
                  _category = category;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
