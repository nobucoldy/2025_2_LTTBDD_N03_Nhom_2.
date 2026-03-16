import 'package:flutter/material.dart';
import '../data/language_data.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? referenceDate;
  final Function(DateTime) onDateSelected;
  final String locale;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    this.referenceDate,
    required this.onDateSelected,
    required this.locale,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime tempDate;

  String t(String key) => localizedText[widget.locale]?[key] ?? key;

  @override
  void initState() {
    super.initState();
    tempDate = widget.initialDate;
  }

  void _addMonthsFromReference(int monthsToAdd) {
    final DateTime baseDate = widget.referenceDate ?? DateTime.now();
    setState(() {
      tempDate = DateTime(
        baseDate.year,
        baseDate.month + monthsToAdd,
        baseDate.day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 520,
      child: Column(
        children: [
          Expanded(
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: CalendarDatePicker(
                key: ValueKey(tempDate),
                initialDate: tempDate,
                firstDate:
                    (widget.referenceDate != null &&
                        widget.referenceDate!.isBefore(tempDate))
                    ? widget.referenceDate!
                    : (tempDate.isBefore(DateTime(2023))
                          ? tempDate
                          : DateTime(2023)),
                lastDate: DateTime(2035),
                onDateChanged: (date) {
                  setState(() => tempDate = date);
                },
              ),
            ),
          ),

          Wrap(
            spacing: 12,
            children: [
              _buildMonthBtn(t('date_1m'), 1, isDark),
              _buildMonthBtn(t('date_3m'), 3, isDark),
              _buildMonthBtn(t('date_6m'), 6, isDark),
              _buildMonthBtn(t('date_1y'), 12, isDark),
            ],
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: isDark
                    ? theme.colorScheme.primary
                    : Colors.purple,
                foregroundColor: isDark ? Colors.black : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                widget.onDateSelected(tempDate);
                Navigator.pop(context);
              },
              child: Text(
                t('date_confirm'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMonthBtn(String title, int months, bool isDark) {
    return ActionChip(
      label: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.purple[200] : Colors.purple,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isDark
          ? Colors.purple.withOpacity(0.15)
          : Colors.purple[100]?.withOpacity(0.3),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => _addMonthsFromReference(months),
    );
  }
}
