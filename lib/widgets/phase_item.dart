import 'package:flutter/material.dart';
import '../models/phase_model.dart';

class PhaseItem extends StatefulWidget {
  final int index;
  final PhaseModel phase;
  final Function(String) onTitleChanged;
  final Function(String) onAddTask;
  final VoidCallback onDeletePhase;

  const PhaseItem({
    super.key,
    required this.index,
    required this.phase,
    required this.onTitleChanged,
    required this.onAddTask,
    required this.onDeletePhase,
  });

  @override
  State<PhaseItem> createState() => _PhaseItemState();
}

class _PhaseItemState extends State<PhaseItem> {
  bool _isAddingTask = false;
  final TextEditingController _taskController = TextEditingController();

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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.purple[100],
                child: Text(
                  "${widget.index + 1}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: widget.phase.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: widget.onTitleChanged,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: widget.onDeletePhase,
              ),
            ],
          ),
          const Divider(height: 24),
          ...widget.phase.tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 10),
                  Text(task.title, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),

          if (_isAddingTask)
            TextField(
              controller: _taskController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Việc cần làm...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 28),
              ),
              onSubmitted: (_) => _submitTask(),
              onTapOutside: (_) => _submitTask(),
            )
          else
            TextButton.icon(
              onPressed: () => setState(() => _isAddingTask = true),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text("Thêm nhiệm vụ"),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}
