import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../data/category_data.dart';

class CategoryPickerService {
  static Future<CategoryModel?> show({
    required BuildContext context,
    required GlobalKey anchorKey,
  }) async {
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

    return await showMenu<CategoryModel?>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: [
        _buildPopupItem(
          null,
          'Không thể loại',
          Icons.folder_off_rounded,
          Colors.grey,
        ),
        ...sampleCategories.map(
          (cat) => _buildPopupItem(cat, cat.name, cat.icon, Colors.purple),
        ),
      ],
    );
  }

  static PopupMenuItem<CategoryModel?> _buildPopupItem(
    CategoryModel? value,
    String text,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem<CategoryModel?>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
