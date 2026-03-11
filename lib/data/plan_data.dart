import '../models/plan_model.dart';
import '../models/phase_model.dart';
import '../models/task_model.dart';
import 'category_data.dart';

final List<PlanModel> samplePlans = [
  PlanModel(
    title: 'Chinh phục IELTS 7.0',
    category: sampleCategories.firstWhere((c) => c.id == 'study'),
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2026, 6, 30),
    isDone: false,
    phases: [
      PhaseModel(
        title: 'Xây dựng nền tảng (Tháng 1-2)',
        tasks: [
          TaskModel(title: 'Học 500 từ vựng cốt lõi', isDone: true),
          TaskModel(title: 'Ôn tập 12 thì tiếng Anh', isDone: true),
          TaskModel(title: 'Luyện nghe podcast hằng ngày', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Kỹ thuật làm bài (Tháng 3-4)',
        tasks: [
          TaskModel(
            title: 'Luyện phương pháp Skimming/Scanning',
            isDone: false,
          ),
          TaskModel(title: 'Học cấu trúc Writing Task 2', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Giải đề & Về đích (Tháng 5-6)',
        tasks: [
          TaskModel(title: 'Giải 20 bộ đề Cambridge', isDone: false),
          TaskModel(title: 'Thi thử tại trung tâm', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'Lộ trình Marathon 21km',
    category: sampleCategories.firstWhere((c) => c.id == 'health'),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 90)),
    isDone: false,
    phases: [
      PhaseModel(
        title: 'Làm quen cơ thể (Tuần 1-4)',
        tasks: [
          TaskModel(title: 'Chạy bộ 3km nhẹ nhàng', isDone: true),
          TaskModel(title: 'Mua giày chạy chuyên dụng', isDone: true),
        ],
      ),
      PhaseModel(
        title: 'Tăng cường sức bền (Tuần 5-8)',
        tasks: [
          TaskModel(title: 'Nâng cự ly lên 10km', isDone: false),
          TaskModel(title: 'Tập bài bổ trợ chân (Leg day)', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Bứt phá (Tuần 9-12)',
        tasks: [
          TaskModel(title: 'Chạy thử cự ly 15km', isDone: false),
          TaskModel(title: 'Đăng ký giải chạy chính thức', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'Xây dựng Portfolio cá nhân',
    category: sampleCategories.firstWhere((c) => c.id == 'work'),
    startDate: DateTime.now().subtract(const Duration(days: 10)),
    endDate: DateTime.now().add(const Duration(days: 45)),
    isDone: false,
    phases: [
      PhaseModel(
        title: 'Chuẩn bị nội dung',
        tasks: [
          TaskModel(title: 'Tổng hợp 5 dự án tốt nhất', isDone: true),
          TaskModel(title: 'Viết Case Study chi tiết', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Thiết kế & Code',
        tasks: [
          TaskModel(title: 'Thiết kế UI trên Figma', isDone: false),
          TaskModel(title: 'Lập trình bằng Flutter Web', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Triển khai',
        tasks: [
          TaskModel(title: 'Mua tên miền cá nhân', isDone: false),
          TaskModel(title: 'Đưa lên Github Pages', isDone: false),
        ],
      ),
    ],
  ),
];
