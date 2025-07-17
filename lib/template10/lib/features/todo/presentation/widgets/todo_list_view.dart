import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';
import 'todo_list_item.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({
    super.key,
    required this.todos,
    required this.selectedTodoIds,
    required this.isLoading,
    required this.onTodoTap,
    required this.onTodoToggle,
    required this.onTodoDelete,
    required this.onTodoEdit,
    required this.onTodoSelect,
  });

  final List<Todo> todos;
  final List<String> selectedTodoIds;
  final bool isLoading;
  final void Function(Todo todo) onTodoTap;
  final void Function(String todoId) onTodoToggle;
  final void Function(String todoId) onTodoDelete;
  final void Function(Todo todo) onTodoEdit;
  final void Function(String todoId) onTodoSelect;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (todos.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        final isSelected = selectedTodoIds.contains(todo.id);

        return TodoListItem(
          todo: todo,
          isSelected: isSelected,
          onTap: () => onTodoTap(todo),
          onToggle: () => onTodoToggle(todo.id),
          onDelete: () => _showDeleteConfirmation(context, todo),
          onEdit: () => onTodoEdit(todo),
          onSelect: () => onTodoSelect(todo.id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rtl,
            size: 120,
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Todoがありません',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '右下の + ボタンから\n新しいTodoを作成しましょう',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todoの削除'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('以下のTodoを削除しますか？'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (todo.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onTodoDelete(todo.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}