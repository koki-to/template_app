import 'package:flutter/material.dart';
import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: todo.isCompleted ? null : (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty) Text(todo.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _PriorityChip(priority: todo.priority),
                const SizedBox(width: 8),
                Text(
                  'Created: ${_formatDate(todo.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: todo.isOverdue && !todo.isCompleted
            ? const Icon(Icons.warning, color: Colors.orange)
            : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}

class _PriorityChip extends StatelessWidget {
  final Priority priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      Priority.low => Colors.green,
      Priority.medium => Colors.orange,
      Priority.high => Colors.red,
    };

    return Chip(
      label: Text(
        priority.name.toUpperCase(),
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide(color: color),
      visualDensity: VisualDensity.compact,
    );
  }
}
