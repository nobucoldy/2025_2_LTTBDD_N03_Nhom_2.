import 'phase_model.dart';

class PlanModel {
  String title;
  String category;
  DateTime? startDate;
  DateTime? endDate;
  List<PhaseModel> phases;

  PlanModel({
    required this.title,
    required this.category,
    this.startDate,
    this.endDate,
    List<PhaseModel>? phases,
  }) : phases = phases ?? [];
}
