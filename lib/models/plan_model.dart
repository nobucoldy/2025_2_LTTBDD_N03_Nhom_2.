import 'category_model.dart';
import 'phase_model.dart';

class PlanModel {
  String title;
  CategoryModel? category;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  List<PhaseModel> phases;

  PlanModel({
    required this.title,
    this.category,
    this.description,
    this.startDate,
    this.endDate,
    required this.phases,
  });

  bool get isDone {
    if (phases.isEmpty) return false;

    final allTasks = phases.expand((phase) => phase.tasks).toList();

    if (allTasks.isEmpty) return false;

    return allTasks.every((task) => task.isDone);
  }
}
