import 'package:flutter/material.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  String _category = 'Cá nhân';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextField nhập kế hoạch
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập kế hoạch mới tại đây',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                // Row các nút chọn category và ngày
                Row(
                  children: [
                    _quickAction(
                      icon: Icons.label_outline,
                      text: _category,
                      onTap: () => _showCategoryPicker(context),
                    ),
                    _quickAction(
                      icon: Icons.calendar_today_outlined,
                      text: _startDate == null
                          ? 'Bắt đầu'
                          : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                      onTap: () => _pickDate(context, true),
                    ),
                    _quickAction(
                      icon: Icons.calendar_today_outlined,
                      text: _endDate == null
                          ? 'Kết thúc'
                          : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                      onTap: () => _pickDate(context, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm chọn ngày
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
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

  // Hàm chọn category
  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Cá nhân', 'Công việc', 'Học tập', 'Sức khỏe']
              .map(
                (e) => ListTile(
                  title: Text(e),
                  onTap: () {
                    setState(() => _category = e);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}

// Widget helper cho các nút nhỏ gọn
Widget _quickAction({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}
