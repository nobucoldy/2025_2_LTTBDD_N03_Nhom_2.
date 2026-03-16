import 'package:flutter/material.dart';
import '../widgets/custom_date_picker.dart';

class DatePickerService {
  static void show({
    required BuildContext context,
    required DateTime? initialDate,
    required DateTime? referenceDate,
    required Function(DateTime) onDateSelected,
    required String locale,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            CustomDatePicker(
              initialDate: initialDate ?? referenceDate ?? DateTime.now(),
              referenceDate: referenceDate,
              onDateSelected: onDateSelected,
              locale: locale,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
