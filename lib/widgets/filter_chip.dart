import 'package:flutter/material.dart';

Widget filterChip(
  String label,
  BuildContext context, {
  bool isSelected = false,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final Color bgColor = isSelected
      ? theme.colorScheme.primary
      : (isDark ? Colors.white10 : Colors.purple.shade50);

  final Color textColor = isSelected
      ? theme.colorScheme.onPrimary
      : (isDark ? Colors.white70 : Colors.black87);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(15),
      border: isDark && !isSelected ? Border.all(color: Colors.white10) : null,
    ),
    child: Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
