import 'category_model.dart';
import 'phase_model.dart';

class PlanModel {
  String title;
  CategoryModel? category;
  DateTime? startDate;
  DateTime? endDate;
  List<PhaseModel> phases;
  bool isDone;

  PlanModel({
    required this.title,
    required this.category,
    this.startDate,
    this.endDate,
    required this.phases,
    this.isDone = false,
  });
}
