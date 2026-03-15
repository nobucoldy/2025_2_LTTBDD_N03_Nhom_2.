import '../models/plan_model.dart';

Map<String, List<PlanModel>> groupPlansByTime(List<PlanModel> plans) {
  DateTime now = DateTime.now();
  Map<String, List<PlanModel>> grouped = {
    'group_month': [],
    'group_3m': [],
    'group_6m': [],
    'group_1y': [],
    'group_later': [],
  };

  for (var plan in plans) {
    if (plan.endDate == null) continue;
    final end = plan.endDate!;
    if (end.isBefore(DateTime(now.year, now.month + 1, 1))) {
      grouped['group_month']!.add(plan);
    } else if (end.isBefore(DateTime(now.year, now.month + 3, now.day))) {
      grouped['group_3m']!.add(plan);
    } else if (end.isBefore(DateTime(now.year, now.month + 6, now.day))) {
      grouped['group_6m']!.add(plan);
    } else if (end.isBefore(DateTime(now.year + 1, now.month, now.day))) {
      grouped['group_1y']!.add(plan);
    } else {
      grouped['group_later']!.add(plan);
    }
  }

  for (var list in grouped.values) {
    list.sort((a, b) => a.endDate!.compareTo(b.endDate!));
  }

  return grouped;
}
