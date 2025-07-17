import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/features/todo/presentation/notifier/todo_notifier.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_app_bar.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_fab.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_filter_chips.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_list_view.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_search_bar.dart';
import 'package:template_app/template10/lib/features/todo/presentation/widgets/todo_statistics_card.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoNotifierProvider);
    final todoNotifier = ref.read(todoNotifierProvider.notifier);

    return Scaffold(
      appBar: TodoAppBar(
        todoState: todoState,
        onDeleteSelected: () async {
          if (todoState.hasSelectedTodos) {
            final success = await todoNotifier.deleteSelectedTodos();
            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${todoState.selectedCount}件のTodoを削除しました'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        onDeleteCompleted: () async {
          final success = await todoNotifier.deleteCompletedTodos();
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('完了済みのTodoを削除しました'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        onSelectAll: () {
          todoNotifier.toggleAllTodosSelection();
        },
        onClearSelection: () {
          todoNotifier.clearSelection();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => todoNotifier.refresh(),
        child: Column(
          children: [
            // 検索バー
            TodoSearchBar(
              searchQuery: todoState.filterSettings.searchQuery,
              onSearchChanged: (query) {
                todoNotifier.updateSearchQuery(query);
              },
              onClearSearch: () {
                todoNotifier.updateSearchQuery('');
              },
            ),

            // フィルタチップス
            TodoFilterChips(
              filterSettings: todoState.filterSettings,
              onFilterTypeChanged: (filterType) {
                todoNotifier.updateFilterType(filterType);
              },
              onSortTypeChanged: (sortType) {
                todoNotifier.updateSortType(sortType);
              },
              onResetFilters: () {
                todoNotifier.resetFilters();
              },
            ),

            // 統計情報カード
            if (todoState.statistics != null && !todoState.statistics!.isEmpty)
              TodoStatisticsCard(
                statistics: todoState.statistics!,
              ),

            // Todoリスト
            Expanded(
              child: TodoListView(
                todos: todoState.filteredTodos,
                selectedTodoIds: todoState.selectedTodoIds,
                isLoading: todoState.isLoading,
                onTodoTap: (todo) {
                  // TODO: Todo詳細画面に遷移
                  _showTodoDetail(context, todo.id);
                },
                onTodoToggle: (todoId) {
                  todoNotifier.toggleTodoCompletion(todoId);
                },
                onTodoDelete: (todoId) async {
                  final success = await todoNotifier.deleteTodo(todoId);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todoを削除しました'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                onTodoEdit: (todo) {
                  // TODO: Todo編集画面に遷移
                  _showTodoEdit(context, todo.id);
                },
                onTodoSelect: (todoId) {
                  todoNotifier.toggleTodoSelection(todoId);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: TodoFab(
        onCreateTodo: () {
          // TODO: Todo作成画面に遷移
          _showTodoCreate(context);
        },
      ),
    );
  }

  void _showTodoDetail(BuildContext context, String todoId) {
    // TODO: 詳細画面への遷移を実装
    Navigator.of(context).pushNamed('/todo/detail', arguments: todoId);
  }

  void _showTodoEdit(BuildContext context, String todoId) {
    // TODO: 編集画面への遷移を実装
    Navigator.of(context).pushNamed('/todo/edit', arguments: todoId);
  }

  void _showTodoCreate(BuildContext context) {
    // TODO: 作成画面への遷移を実装
    Navigator.of(context).pushNamed('/todo/create');
  }
}
