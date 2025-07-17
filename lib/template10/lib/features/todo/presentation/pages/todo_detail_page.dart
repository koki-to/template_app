import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/features/todo/presentation/notifier/todo_notifier.dart';

import '../../domain/entities/todo.dart';

class TodoDetailPage extends ConsumerWidget {
  const TodoDetailPage({
    super.key,
    required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoNotifierProvider.notifier);
    final todoState = ref.watch(todoNotifierProvider);

    // 詳細表示対象のTodoを検索
    final todo = todoState.todos.where((t) => t.id == todoId).firstOrNull;

    if (todo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Todo詳細'),
        ),
        body: const Center(
          child: Text('Todoが見つかりません'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo詳細'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          // 編集ボタン
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/todo/edit', arguments: todoId);
            },
            tooltip: '編集',
          ),
          // 削除ボタン
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                _showDeleteConfirmation(context, todo, todoNotifier),
            tooltip: '削除',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ステータスカード
            _buildStatusCard(context, todo, todoNotifier),

            const SizedBox(height: 16),

            // 内容カード
            _buildContentCard(context, todo),

            const SizedBox(height: 16),

            // メタ情報カード
            _buildMetaInfoCard(context, todo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoNotifier.toggleTodoCompletion(todoId);
        },
        child: Icon(
          todo.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        ),
        tooltip: todo.isCompleted ? '未完了にする' : '完了にする',
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context, Todo todo, TodoNotifier todoNotifier) {
    final theme = Theme.of(context);
    final isCompleted = todo.isCompleted;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ステータスアイコン
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.green : Colors.orange,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // ステータステキスト
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCompleted ? '完了済み' : '未完了',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isCompleted ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted ? 'このTodoは完了しています' : 'このTodoはまだ完了していません',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // 切り替えボタン
            ElevatedButton(
              onPressed: () {
                todoNotifier.toggleTodoCompletion(todoId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? theme.colorScheme.surfaceVariant
                    : theme.colorScheme.primaryContainer,
                foregroundColor: isCompleted
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onPrimaryContainer,
              ),
              child: Text(isCompleted ? '未完了にする' : '完了にする'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, Todo todo) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Row(
              children: [
                Icon(
                  Icons.article,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '内容',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // タイトル
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'タイトル',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 説明
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '説明',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfoCard(BuildContext context, Todo todo) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '詳細情報',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // メタ情報リスト
            _buildMetaInfoRow(
              context,
              icon: Icons.fingerprint,
              label: 'ID',
              value: todo.id,
              isMonospace: true,
            ),

            const SizedBox(height: 12),

            _buildMetaInfoRow(
              context,
              icon: Icons.schedule,
              label: '作成日時',
              value: _formatFullDateTime(todo.createdAt),
            ),

            const SizedBox(height: 12),

            _buildMetaInfoRow(
              context,
              icon: Icons.update,
              label: '最終更新日時',
              value: _formatFullDateTime(todo.updatedAt),
            ),

            if (todo.updatedAt != todo.createdAt) ...[
              const SizedBox(height: 12),
              _buildMetaInfoRow(
                context,
                icon: Icons.history,
                label: '最終更新',
                value: _getRelativeTime(todo.updatedAt),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMonospace = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: isMonospace ? 'monospace' : null,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  String _formatFullDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'たった今';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}週間前';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}ヶ月前';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}年前';
    }
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
            const Text('このTodoを削除しますか？'),
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
                Navigator.of(context).pop(); // 詳細画面を閉じる
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
