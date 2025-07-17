import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/features/todo/domain/entities/todo.dart';
import 'package:template_app/template10/lib/features/todo/presentation/notifier/todo_notifier.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_form.dart';

class TodoEditPage extends ConsumerWidget {
  const TodoEditPage({
    super.key,
    required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoNotifierProvider.notifier);
    final todoState = ref.watch(todoNotifierProvider);

    // 編集対象のTodoを検索
    final todo = todoState.todos.where((t) => t.id == todoId).firstOrNull;

    if (todo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Todo編集'),
        ),
        body: const Center(
          child: Text('Todoが見つかりません'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo編集'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          // 削除ボタン
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                _showDeleteConfirmation(context, todo, todoNotifier),
            tooltip: '削除',
          ),
        ],
      ),
      body: TodoForm(
        isCreating: false,
        initialTitle: todo.title,
        initialDescription: todo.description,
        isLoading: todoState.isUpdating,
        onSubmit: (title, description) async {
          final success = await todoNotifier.updateTodo(
            id: todoId,
            title: title,
            description: description,
          );

          if (success && context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Todoを更新しました'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (context.mounted && todoState.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(todoState.errorMessage ?? '更新に失敗しました'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Todo todo,
    TodoNotifier todoNotifier,
  ) {
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
                      maxLines: 3,
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
            onPressed: () async {
              Navigator.of(context).pop(); // ダイアログを閉じる

              final success = await todoNotifier.deleteTodo(todo.id);
              if (success && context.mounted) {
                Navigator.of(context).pop(); // 編集画面を閉じる
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todoを削除しました'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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
