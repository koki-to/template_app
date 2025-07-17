import 'package:flutter/material.dart';
import 'package:template_app/template10/lib/features/todo/service/todo_filter_service.dart';

class TodoFilterChips extends StatelessWidget {
  const TodoFilterChips({
    super.key,
    required this.filterSettings,
    required this.onFilterTypeChanged,
    required this.onSortTypeChanged,
    required this.onResetFilters,
  });

  final TodoFilterSettings filterSettings;
  final void Function(TodoFilterType filterType) onFilterTypeChanged;
  final void Function(TodoSortType sortType) onSortTypeChanged;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // フィルタ行
          Row(
            children: [
              Text(
                'フィルタ:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: TodoFilterType.values.map((filterType) {
                      final isSelected =
                          filterSettings.filterType == filterType;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getFilterTypeLabel(filterType)),
                          selected: isSelected,
                          onSelected: (_) => onFilterTypeChanged(filterType),
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: theme.colorScheme.primaryContainer,
                          checkmarkColor: theme.colorScheme.onPrimaryContainer,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ソート行
          Row(
            children: [
              Text(
                'ソート:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...TodoSortType.values.take(4).map((sortType) {
                        final isSelected = filterSettings.sortType == sortType;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_getSortTypeLabel(sortType)),
                            selected: isSelected,
                            onSelected: (_) => onSortTypeChanged(sortType),
                            backgroundColor: theme.colorScheme.surface,
                            selectedColor: theme.colorScheme.secondaryContainer,
                            checkmarkColor:
                                theme.colorScheme.onSecondaryContainer,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? theme.colorScheme.onSecondaryContainer
                                  : theme.colorScheme.onSurface,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),

                      // その他のソートオプション
                      PopupMenuButton<TodoSortType>(
                        child: Chip(
                          label: const Text('その他'),
                          avatar: const Icon(Icons.expand_more, size: 16),
                          backgroundColor: theme.colorScheme.surface,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                        onSelected: onSortTypeChanged,
                        itemBuilder: (context) =>
                            TodoSortType.values.skip(4).map((sortType) {
                          return PopupMenuItem(
                            value: sortType,
                            child: Text(_getSortTypeLabel(sortType)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // リセットボタン
          if (!filterSettings.isDefault) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onResetFilters,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('リセット'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _getFilterTypeLabel(TodoFilterType filterType) {
    switch (filterType) {
      case TodoFilterType.all:
        return '全て';
      case TodoFilterType.completed:
        return '完了済み';
      case TodoFilterType.incomplete:
        return '未完了';
    }
  }

  String _getSortTypeLabel(TodoSortType sortType) {
    switch (sortType) {
      case TodoSortType.createdAtDesc:
        return '作成日↓';
      case TodoSortType.createdAtAsc:
        return '作成日↑';
      case TodoSortType.updatedAtDesc:
        return '更新日↓';
      case TodoSortType.updatedAtAsc:
        return '更新日↑';
      case TodoSortType.titleAsc:
        return 'タイトル↑';
      case TodoSortType.titleDesc:
        return 'タイトル↓';
      case TodoSortType.completionStatus:
        return '完了状態順';
    }
  }
}
