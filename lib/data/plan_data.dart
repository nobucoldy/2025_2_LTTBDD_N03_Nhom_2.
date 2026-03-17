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
    title: 'Quản lý Tài chính Cá nhân',
    category: _getCat('finance'),
    startDate: DateTime(2026, 1, 1),
    endDate: DateTime(2027, 12, 31),
    isFavorite: true,
    phases: [
      PhaseModel(
        title: 'Giai đoạn 1: Thiết lập ngân sách',
        tasks: [
          TaskModel(
            title: 'Liệt kê các khoản thu nhập hàng tháng',
            isDone: true,
          ),
          TaskModel(title: 'Thống kê chi tiêu thiết yếu', isDone: true),
          TaskModel(
            title: 'Xác định số tiền tiết kiệm mục tiêu',
            isDone: false,
          ),
        ],
      ),
      PhaseModel(
        title: 'Giai đoạn 2: Tối ưu hóa chi tiêu',
        tasks: [
          TaskModel(
            title: 'Cắt giảm các chi phí không cần thiết',
            isDone: false,
          ),
          TaskModel(title: 'Tìm kiếm nguồn thu nhập thụ động', isDone: false),
          TaskModel(title: 'Ghi chép chi tiêu mỗi ngày', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'Học lập trình Flutter',
    category: _getCat('work'),
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2027, 3, 1),
    isFavorite: true,
    phases: [
      PhaseModel(
        title: 'Cơ bản về Dart',
        tasks: [
          TaskModel(title: 'Biến và các kiểu dữ liệu cơ bản', isDone: true),
          TaskModel(title: 'Vòng lặp và cấu trúc điều kiện', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Xây dựng giao diện (UI)',
        tasks: [
          TaskModel(
            title: 'Làm quen với Stateless & Stateful Widget',
            isDone: false,
          ),
          TaskModel(
            title: 'Sử dụng Layout Widgets (Row, Column)',
            isDone: false,
          ),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'Kế hoạch Cải thiện Sức khỏe',
    category: _getCat('life'),
    startDate: DateTime.now().subtract(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 60)),
    isFavorite: false,
    phases: [
      PhaseModel(
        title: 'Thay đổi chế độ ăn uống',
        tasks: [
          TaskModel(title: 'Uống đủ 2 lít nước mỗi ngày', isDone: true),
          TaskModel(title: 'Giảm lượng đường và tinh bột', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Rèn luyện thể chất',
        tasks: [
          TaskModel(title: 'Chạy bộ 30 phút mỗi sáng', isDone: true),
          TaskModel(title: 'Tập các bài Cardio cơ bản', isDone: false),
        ],
      ),
    ],
  ),

  PlanModel(
    title: 'Học tiếng Nhật N5',
    category: _getCat('study'),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 180)),
    isFavorite: false,
    phases: [
      PhaseModel(
        title: 'Học bảng chữ cái',
        tasks: [
          TaskModel(title: 'Thuộc bảng chữ cái Hiragana', isDone: true),
          TaskModel(title: 'Thuộc bảng chữ cái Katakana', isDone: false),
        ],
      ),
      PhaseModel(
        title: 'Ngữ pháp cơ bản',
        tasks: [
          TaskModel(title: 'Học 10 mẫu câu đầu tiên', isDone: false),
          TaskModel(title: 'Luyện nghe các đoạn hội thoại ngắn', isDone: false),
        ],
      ),
    ],
  ),
];
