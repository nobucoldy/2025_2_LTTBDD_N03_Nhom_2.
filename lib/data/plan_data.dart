import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/task_model.dart';
import 'category_data.dart';

dynamic _getCat(String id) {
  return sampleCategories.firstWhere(
    (c) => c.id == id,
    orElse: () => sampleCategories.first,
  );
}

final List<PlanModel> samplePlans = [
  PlanModel(
    title: 'plan_finance_title',
    category: _getCat('finance'),
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2027, 12, 31),
    phases: [
      PhaseModel(
        title: 'plan_finance_p1',
        tasks: [
          TaskModel(title: 'plan_finance_p1_t1', isDone: true),
          TaskModel(title: 'plan_finance_p1_t2', isDone: true),
          TaskModel(title: 'plan_finance_p1_t3', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'plan_finance_p2',
        tasks: [
          TaskModel(title: 'plan_finance_p2_t1', isDone: false),
          TaskModel(title: 'plan_finance_p2_t2', isDone: false),
          TaskModel(title: 'plan_finance_p2_t3', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'plan_finance_p3',
        tasks: [
          TaskModel(title: 'plan_finance_p3_t1', isDone: false),
          TaskModel(title: 'plan_finance_p3_t2', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'plan_flutter_title',
    category: _getCat('work'),
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2027, 3, 1),
    phases: [
      PhaseModel(
        title: 'plan_flutter_p1',
        tasks: [
          TaskModel(title: 'plan_flutter_p1_t1', isDone: true),
          TaskModel(title: 'plan_flutter_p1_t2', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'plan_flutter_p2',
        tasks: [
          TaskModel(title: 'plan_flutter_p2_t1', isDone: false),
          TaskModel(title: 'plan_flutter_p2_t2', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'plan_flutter_p3',
        tasks: [
          TaskModel(title: 'plan_flutter_p3_t1', isDone: false),
          TaskModel(title: 'plan_flutter_p3_t2', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'plan_life_title',
    category: _getCat('life'),
    startDate: DateTime.now().subtract(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 60)),
    phases: [
      PhaseModel(
        title: 'plan_life_p1',
        tasks: [
          TaskModel(title: 'plan_life_p1_t1', isDone: true),
          TaskModel(title: 'plan_life_p1_t2', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'plan_life_p2',
        tasks: [
          TaskModel(title: 'plan_life_p2_t1', isDone: true),
          TaskModel(title: 'plan_life_p2_t2', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'plan_ja_title',
    category: _getCat('study'),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 180)),
    phases: [
      PhaseModel(
        title: 'plan_ja_p1',
        tasks: [
          TaskModel(title: 'plan_ja_p1_t1', isDone: true),
          TaskModel(title: 'plan_ja_p1_t2', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'plan_ja_p2',
        tasks: [
          TaskModel(title: 'plan_ja_p2_t1', isDone: false),
          TaskModel(title: 'plan_ja_p2_t2', isDone: false),
        ],
      ),
    ],
  ),
];
