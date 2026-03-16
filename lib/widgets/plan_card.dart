import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../data/language_data.dart';

Widget planCard(PlanModel plan, String locale, BuildContext context) {
  final bool isDone = plan.isDone;
  final double progress = plan.progress;

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  String t(String key) => localizedText[locale]?[key] ?? key;

  final Color contentColor = isDone
      ? (isDark ? Colors.white30 : Colors.grey.shade400)
      : theme.colorScheme.primary;

  final Color titleColor = isDone
      ? (isDark ? Colors.white38 : Colors.grey.shade500)
      : theme.colorScheme.onSurface;

  return AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: isDone ? 0.6 : 1.0,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone
            ? (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDone
              ? (isDark ? Colors.white10 : Colors.grey.shade200)
              : theme.colorScheme.primary.withOpacity(0.1),
        ),
        boxShadow: [
          if (!isDone && !isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                plan.category?.icon ?? Icons.folder_open,
                color: contentColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        "${plan.startDate?.day}/${plan.startDate?.month}/${plan.startDate?.year} - ${plan.endDate?.day}/${plan.endDate?.month}/${plan.endDate?.year}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: contentColor.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      t(plan.title),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: isDark
                            ? Colors.white24
                            : Colors.grey.shade400,
                        decorationThickness: 2,
                      ),
                    ),
                    if (plan.description != null &&
                        plan.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          plan.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDone
                    ? (isDark ? Colors.white12 : Colors.grey.shade300)
                    : Colors.grey.shade400,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? Colors.white10
                        : Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDone
                          ? Colors.green.shade400
                          : (isDark
                                ? theme.colorScheme.primary
                                : Colors.purple.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDone
                      ? Colors.green.shade400
                      : (isDark
                            ? theme.colorScheme.primary
                            : Colors.purple.shade400),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
