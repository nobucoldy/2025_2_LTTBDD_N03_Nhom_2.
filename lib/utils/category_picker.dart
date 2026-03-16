import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../data/category_data.dart';
import '../data/language_data.dart';

class CategoryPickerService {
  static Future<CategoryModel?> show({
    required BuildContext context,
    required GlobalKey anchorKey,
    required String locale,
  }) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    String t(String key) => localizedText[locale]?[key] ?? key;

    final RenderBox button =
        anchorKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, 45), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<CategoryModel?>(
      context: context,
      position: position,
      constraints: const BoxConstraints(maxWidth: 220, maxHeight: 400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isDark ? BorderSide(color: Colors.white10) : BorderSide.none,
      ),
      items: [
        PopupMenuItem<CategoryModel?>(
          value: null,
          child: Row(
            children: [
              Icon(
                Icons.folder_off_rounded,
                size: 18,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                t('cat_none'),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ),

        const PopupMenuDivider(),

        ...sampleCategories.map(
          (cat) => _buildPopupItem(
            cat,
            t(cat.name),
            cat.icon,
            isDark ? Colors.purple[200]! : Colors.purple,
            isDark,
          ),
        ),

        const PopupMenuDivider(),

        PopupMenuItem<CategoryModel?>(
          value: const CategoryModel(
            id: 'add_new_id',
            name: 'add_new',
            icon: Icons.add,
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 18,
                color: isDark ? Colors.blue[300] : Colors.blue,
              ),
              const SizedBox(width: 12),
              Text(
                t('cat_add_new'),
                style: TextStyle(
                  color: isDark ? Colors.blue[300] : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return result;
  }

  static PopupMenuItem<CategoryModel?> _buildPopupItem(
    CategoryModel? value,
    String text,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return PopupMenuItem<CategoryModel?>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
