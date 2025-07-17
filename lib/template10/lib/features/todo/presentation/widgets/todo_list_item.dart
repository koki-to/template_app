import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.isSelected,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onSelect,
  });

  final Todo todo;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = todo.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 8 : 1,
      color: isSelected 
          ? theme.colorScheme.primaryContainer.withOpacity(0.5)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 選択状態またはチェックボックス
              isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 24,
                    )
                  : Checkbox(
                      value: isCompleted,
                      onChanged: (_) => onToggle(),
                      shape: const CircleBorder(),
                    ),
              
              const SizedBox(width: 16),
              
              // Todo内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // タイトル
                    Text(
                      todo.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                        color: isCompleted 
                            ? theme.colorScheme.outline
                            : null,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    if (todo.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        todo.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                          color: isCompleted 
                              ? theme.colorScheme.outline
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: 8),
                    
                    // メタ情報
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(todo.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        if (todo.updatedAt != todo.createdAt) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.edit,
                            size: 14,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(todo.updatedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // アクションボタン
              if (!isSelected) ...[
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.outline,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                      case 'select':
                        onSelect();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('編集'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'select',
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('選択'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(
                          '削除',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // 今日の場合は時間のみ表示
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨日';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}週間前';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}ヶ月前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}