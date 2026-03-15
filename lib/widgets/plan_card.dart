import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../data/language_data.dart';

Widget planCard(PlanModel plan, String locale) {
  final bool isDone = plan.isDone;
  final double progress = plan.progress;

  String t(String key) => localizedText[locale]?[key] ?? key;

  final Color contentColor = isDone ? Colors.grey.shade400 : Colors.purple;
  final Color titleColor = isDone ? Colors.grey.shade500 : Colors.black87;

  return AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: isDone ? 0.6 : 1.0,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDone ? Colors.grey.shade200 : Colors.purple.withOpacity(0.1),
        ),
        boxShadow: [
          if (!isDone)
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
                plan.category?.icon ?? Icons.assignment_outlined,
                color: contentColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plan.category != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          t(plan.category!.name).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: contentColor.withOpacity(0.7),
                            letterSpacing: 1,
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
                        decorationColor: Colors.grey.shade400,
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
                            color: Colors.grey.shade500,
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
                color: isDone ? Colors.grey.shade300 : Colors.grey.shade400,
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
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDone ? Colors.green.shade300 : Colors.purple.shade300,
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
                      : Colors.purple.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
