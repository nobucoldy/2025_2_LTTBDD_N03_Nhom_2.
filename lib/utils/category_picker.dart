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
      constraints: const BoxConstraints(maxWidth: 220, maxHeight: 400),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: [
        const PopupMenuItem<CategoryModel?>(
          value: null,
          child: Row(
            children: [
              Icon(Icons.folder_off_rounded, size: 18, color: Colors.grey),
              SizedBox(width: 12),
              Text('Không có thể loại', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuDivider(),

        ...sampleCategories.map(
          (cat) => _buildPopupItem(cat, cat.name, cat.icon, Colors.purple),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem<CategoryModel?>(
          value: CategoryModel(
            id: 'add_new_id',
            name: 'Add New',
            icon: Icons.add,
          ),
          child: Row(
            children: [
              Icon(Icons.add_circle_outline, size: 18, color: Colors.blue),
              SizedBox(width: 12),
              Text(
                'Thêm thể loại mới',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
