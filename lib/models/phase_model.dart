import 'task_model.dart';

class PhaseModel {
  String title;
  List<TaskModel> tasks;

  PhaseModel({required this.title, List<TaskModel>? tasks})
    : tasks = tasks ?? [];
}
