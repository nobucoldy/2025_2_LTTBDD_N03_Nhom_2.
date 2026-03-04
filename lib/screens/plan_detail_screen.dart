import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../models/phase_model.dart';

class PlanDetailScreen extends StatelessWidget {
  final PlanModel plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thể loại: ${plan.category?.name ?? 'Không có'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Thời gian: ${plan.startDate != null ? "${plan.startDate!.day}/${plan.startDate!.month}/${plan.startDate!.year}" : "-"} '
              '- ${plan.endDate != null ? "${plan.endDate!.day}/${plan.endDate!.month}/${plan.endDate!.year}" : "-"}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Các giai đoạn:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: plan.phases.length,
                itemBuilder: (context, index) {
                  final PhaseModel phase = plan.phases[index];
                  return Card(
                    child: ListTile(
                      title: Text(phase.title),
                      subtitle: phase.tasks.isEmpty
                          ? const Text('Chưa có nhiệm vụ')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: phase.tasks
                                  .map((t) => Text('- $t'))
                                  .toList(),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
