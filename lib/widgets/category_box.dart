import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../data/language_data.dart';

class CategoryBox extends StatelessWidget {
  final CategoryModel? category;
  final VoidCallback onTap;
  final String locale;

  const CategoryBox({
    super.key,
    required this.category,
    required this.onTap,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String t(String key) => localizedText[locale]?[key] ?? key;

    final Color bgColor = isDark
        ? theme.colorScheme.primary.withOpacity(0.15)
        : Colors.purple.shade50;

    final Color borderColor = isDark
        ? theme.colorScheme.primary.withOpacity(0.3)
        : Colors.purple.shade200;

    final Color textColor = isDark ? theme.colorScheme.primary : Colors.purple;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        height: 22,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            category != null ? t(category!.name) : t('cat_none'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
