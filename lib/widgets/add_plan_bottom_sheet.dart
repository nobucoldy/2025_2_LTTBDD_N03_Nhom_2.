import 'package:flutter/material.dart';

class AddPlanBottomSheet extends StatefulWidget {
  const AddPlanBottomSheet({super.key});

  @override
  State<AddPlanBottomSheet> createState() => _AddPlanBottomSheetState();
}

class _AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Nhập kế hoạch mới tại đây',
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(children: [Icon(Icons.add_circle_outline_outlined)]),
        ],
      ),
    );
  }
}
