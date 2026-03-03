import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/task_model.dart';

List<PlanModel> samplePlans = [
  PlanModel(
    title: 'Ôn thi cuối kỳ',
    category: 'Học tập',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 30),
    phases: [
      PhaseModel(
        title: 'Giai đoạn 1',
        tasks: [
          TaskModel(title: 'Học chương 1'),
          TaskModel(title: 'Học chương 2'),
        ],
      ),
      PhaseModel(
        title: 'Giai đoạn 2',
        tasks: [TaskModel(title: 'Làm đề thi thử')],
      ),
    ],
  ),

  PlanModel(
    title: 'Tập thể dục',
    category: 'Sức khỏe',
    phases: [
      PhaseModel(
        title: 'Tuần 1',
        tasks: [
          TaskModel(title: 'Chạy bộ 20 phút'),
          TaskModel(title: 'Hít đất'),
        ],
      ),
    ],
  ),
  PlanModel(
    title: 'Ôn thi cuối kỳ',
    category: 'Học tập',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 30),
    phases: [
      PhaseModel(
        title: 'Giai đoạn 1',
        tasks: [
          TaskModel(title: 'Học chương 1'),
          TaskModel(title: 'Học chương 2'),
        ],
      ),
      PhaseModel(
        title: 'Giai đoạn 2',
        tasks: [TaskModel(title: 'Làm đề thi thử')],
      ),
    ],
  ),

  PlanModel(
    title: 'Ôn thi cuối kỳ',
    category: 'Học tập',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 30),
    phases: [
      PhaseModel(
        title: 'Giai đoạn 1',
        tasks: [
          TaskModel(title: 'Học chương 1'),
          TaskModel(title: 'Học chương 2'),
        ],
      ),
      PhaseModel(
        title: 'Giai đoạn 2',
        tasks: [TaskModel(title: 'Làm đề thi thử')],
      ),
    ],
  ),
];
