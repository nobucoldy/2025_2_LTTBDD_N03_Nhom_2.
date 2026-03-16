import 'package:flutter/material.dart';
import '../models/phase_model.dart';
import '../data/language_data.dart';

class PhaseItem extends StatefulWidget {
  final int index;
  final PhaseModel phase;
  final Function(String) onTitleChanged;
  final Function(String) onAddTask;
  final VoidCallback onDeletePhase;
  final String locale;

  const PhaseItem({
    super.key,
    required this.index,
    required this.phase,
    required this.onTitleChanged,
    required this.onAddTask,
    required this.onDeletePhase,
    required this.locale,
  });

  @override
  State<PhaseItem> createState() => _PhaseItemState();
}

class _PhaseItemState extends State<PhaseItem> {
  bool _isAddingTask = false;
  final TextEditingController _taskController = TextEditingController();

  String t(String key) => localizedText[widget.locale]?[key] ?? key;

  void _submitTask() {
    if (_taskController.text.trim().isNotEmpty) {
      widget.onAddTask(_taskController.text.trim());
      _taskController.clear();
    }
    setState(() => _isAddingTask = false);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isDark
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.purple[100],
                child: Text(
                  "${widget.index + 1}",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.purple[200] : Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: widget.phase.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: widget.onTitleChanged,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: isDark ? Colors.white38 : Colors.grey,
                ),
                onPressed: widget.onDeletePhase,
              ),
            ],
          ),
          Divider(
            height: 24,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          ...widget.phase.tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: isDark ? Colors.white24 : Colors.grey[400],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isAddingTask)
            TextField(
              controller: _taskController,
              autofocus: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: t('add_task_hint'),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white24 : Colors.grey[400],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 28),
              ),
              onSubmitted: (_) => _submitTask(),
              onTapOutside: (_) => _submitTask(),
            )
          else
            TextButton.icon(
              onPressed: () => setState(() => _isAddingTask = true),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(t('add_task')),
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}
