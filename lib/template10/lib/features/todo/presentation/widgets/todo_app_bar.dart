import 'package:flutter/material.dart';
import 'package:template_app/template10/lib/features/todo/presentation/notifier/todo_state.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TodoAppBar({
    super.key,
    required this.todoState,
    required this.onDeleteSelected,
    required this.onDeleteCompleted,
    required this.onSelectAll,
    required this.onClearSelection,
  });

  final TodoState todoState;
  final VoidCallback onDeleteSelected;
  final VoidCallback onDeleteCompleted;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelectedTodos = todoState.hasSelectedTodos;

    return AppBar(
      title: hasSelectedTodos
          ? Text('${todoState.selectedCount}件選択中')
          : const Text('Todo'),
      backgroundColor:
          hasSelectedTodos ? theme.colorScheme.primaryContainer : null,
      foregroundColor:
          hasSelectedTodos ? theme.colorScheme.onPrimaryContainer : null,
      leading: hasSelectedTodos
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClearSelection,
              tooltip: '選択を解除',
            )
          : null,
      actions: [
        if (hasSelectedTodos) ...[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: todoState.isDeleting ? null : onDeleteSelected,
            tooltip: '選択したTodoを削除',
          ),
        ] else ...[
          if (todoState.filteredTodos.isNotEmpty)
            IconButton(
              icon: todoState.areAllTodosSelected
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: onSelectAll,
              tooltip: todoState.areAllTodosSelected ? '全選択を解除' : '全て選択',
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'delete_completed':
                  _showDeleteCompletedDialog(context);
                  break;
                case 'statistics':
                  _showStatisticsDialog(context);
                  break;
                case 'about':
                  _showAboutDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_completed',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('完了済みを削除'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (todoState.statistics != null)
                const PopupMenuItem(
                  value: 'statistics',
                  child: ListTile(
                    leading: Icon(Icons.analytics),
                    title: Text('統計情報'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              const PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('アプリについて'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ],
      elevation: hasSelectedTodos ? 4 : null,
    );
  }

  void _showDeleteCompletedDialog(BuildContext context) {
    final completedCount =
        todoState.todos.where((todo) => todo.isCompleted).length;

    if (completedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('削除する完了済みTodoがありません'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('完了済みTodoの削除'),
        content: Text('完了済みのTodo（${completedCount}件）を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDeleteCompleted();
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog(BuildContext context) {
    final statistics = todoState.statistics;
    if (statistics == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('統計情報'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('総Todo数', '${statistics.totalCount}件'),
            _buildStatRow('完了済み', '${statistics.completedCount}件'),
            _buildStatRow('未完了', '${statistics.incompleteCount}件'),
            _buildStatRow('完了率',
                '${statistics.completionPercentage.toStringAsFixed(1)}%'),
            _buildStatRow('今日作成', '${statistics.todayCreatedCount}件'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Todo App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.checklist, size: 48),
      children: [
        const Text('プロフェッショナルレベルのTodoアプリです。'),
        const SizedBox(height: 8),
        const Text('機能:'),
        const Text('• Todo作成・編集・削除'),
        const Text('• 検索・フィルタリング'),
        const Text('• 統計情報表示'),
        const Text('• 一括操作'),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
