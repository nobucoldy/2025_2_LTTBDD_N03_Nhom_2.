import 'package:flutter/material.dart';
import '../data/plan_data.dart';
import '../data/language_data.dart';

class DashboardScreen extends StatelessWidget {
  final String locale;

  const DashboardScreen({super.key, required this.locale});

  String t(String key) => localizedText[locale]?[key] ?? key;

  @override
  Widget build(BuildContext context) {
    final int totalPlans = samplePlans.length;
    final int completedPlans = samplePlans.where((p) => p.isDone).length;

    final double avgProgress = totalPlans > 0
        ? samplePlans.map((p) => p.progress).reduce((a, b) => a + b) /
              totalPlans
        : 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          t('dashboard'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tiến độ tổng thể (%)
            _buildOverallProgress(avgProgress),

            const SizedBox(height: 25),

            // 2. Chỉ giữ lại 2 thẻ: Tổng số và Hoàn thành
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    t('all_cat'),
                    totalPlans.toString(),
                    Icons.assignment,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    t('completed_title'),
                    completedPlans.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // 3. Danh sách thể loại kèm tiến độ chi tiết
            Text(
              t('add_category'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildCategoryList(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress(double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.purple[700]!],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('db_overall_progress'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  t('db_encouragement'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    Map<dynamic, List<double>> catStats = {};

    for (var plan in samplePlans) {
      var cat = plan.category;
      if (!catStats.containsKey(cat)) {
        catStats[cat] = [0.0, 0];
      }
      catStats[cat]![0] += plan.progress;
      catStats[cat]![1] += 1;
    }

    return Column(
      children: catStats.entries.map((e) {
        final category = e.key;
        final double totalProgress = e.value[0];
        final int count = e.value[1].toInt();
        final double avgCatProgress = count > 0 ? totalProgress / count : 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    category != null ? category.icon : Icons.folder_open,
                    size: 22,
                    color: Colors.purple[700],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      category != null ? t(category.name) : t('cat_none'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "$count ${t('title').toLowerCase()}",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: avgCatProgress,
                        minHeight: 6,
                        backgroundColor: Colors.grey[100],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          avgCatProgress == 1.0
                              ? Colors.green
                              : Colors.purple[300]!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${(avgCatProgress * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: avgCatProgress == 1.0
                          ? Colors.green
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
