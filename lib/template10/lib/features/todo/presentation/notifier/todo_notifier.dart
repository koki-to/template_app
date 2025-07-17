import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/features/todo/service/todo_filter_service.dart';
import 'package:template_app/template10/lib/features/todo/service/todo_service.dart'
    show TodoService, todoServiceProvider;

import 'todo_state.dart';

/// TodoNotifierのProvider
final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return TodoNotifier(todoService);
});

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier(this._todoService) : super(const TodoState()) {
    loadTodos();
  }

  final TodoService _todoService;

  /// 全てのTodoを読み込み
  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, failure: null);

    final result = await _todoService.getAllTodos();

    result.when(
      onSuccess: (todos) {
        state = state.copyWith(
          todos: todos,
          isLoading: false,
        );
        _applyFilters();
        _loadStatistics();
      },
      onError: (failure) {
        state = state.copyWith(
          isLoading: false,
          failure: failure,
        );
      },
    );
  }

  /// 新しいTodoを作成
  Future<bool> createTodo({
    required String title,
    required String description,
  }) async {
    state = state.copyWith(isCreating: true, failure: null);

    final result = await _todoService.createTodo(
      title: title,
      description: description,
    );

    return result.fold(
      onSuccess: (todo) {
        final updatedTodos = [todo, ...state.todos];
        state = state.copyWith(
          todos: updatedTodos,
          isCreating: false,
        );
        _applyFilters();
        _loadStatistics();
        return true;
      },
      onError: (failure) {
        state = state.copyWith(
          isCreating: false,
          failure: failure,
        );
        return false;
      },
    );
  }

  /// Todoを更新
  Future<bool> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    state = state.copyWith(isUpdating: true, failure: null);

    final result = await _todoService.updateTodo(
      id: id,
      title: title,
      description: description,
    );

    return result.fold(
      onSuccess: (updatedTodo) {
        final updatedTodos = state.todos.map((todo) {
          return todo.id == updatedTodo.id ? updatedTodo : todo;
        }).toList();

        state = state.copyWith(
          todos: updatedTodos,
          isUpdating: false,
        );
        _applyFilters();
        _loadStatistics();
        return true;
      },
      onError: (failure) {
        state = state.copyWith(
          isUpdating: false,
          failure: failure,
        );
        return false;
      },
    );
  }

  /// Todoの完了状態を切り替え
  Future<void> toggleTodoCompletion(String id) async {
    final result = await _todoService.toggleTodoCompletion(id);

    result.when(
      onSuccess: (updatedTodo) {
        final updatedTodos = state.todos.map((todo) {
          return todo.id == updatedTodo.id ? updatedTodo : todo;
        }).toList();

        state = state.copyWith(todos: updatedTodos);
        _applyFilters();
        _loadStatistics();
      },
      onError: (failure) {
        state = state.copyWith(failure: failure);
      },
    );
  }

  /// Todoを削除
  Future<bool> deleteTodo(String id) async {
    state = state.copyWith(isDeleting: true, failure: null);

    final result = await _todoService.deleteTodo(id);

    return result.fold(
      onSuccess: (_) {
        final updatedTodos =
            state.todos.where((todo) => todo.id != id).toList();
        final updatedSelectedIds = state.selectedTodoIds
            .where((selectedId) => selectedId != id)
            .toList();

        state = state.copyWith(
          todos: updatedTodos,
          selectedTodoIds: updatedSelectedIds,
          isDeleting: false,
        );
        _applyFilters();
        _loadStatistics();
        return true;
      },
      onError: (failure) {
        state = state.copyWith(
          isDeleting: false,
          failure: failure,
        );
        return false;
      },
    );
  }

  /// 選択されたTodoを一括削除
  Future<bool> deleteSelectedTodos() async {
    if (state.selectedTodoIds.isEmpty) return false;

    state = state.copyWith(isDeleting: true, failure: null);

    final result = await _todoService.deleteTodos(state.selectedTodoIds);

    return result.fold(
      onSuccess: (_) {
        final deletedIds = Set<String>.from(state.selectedTodoIds);
        final updatedTodos =
            state.todos.where((todo) => !deletedIds.contains(todo.id)).toList();

        state = state.copyWith(
          todos: updatedTodos,
          selectedTodoIds: [],
          isDeleting: false,
        );
        _applyFilters();
        _loadStatistics();
        return true;
      },
      onError: (failure) {
        state = state.copyWith(
          isDeleting: false,
          failure: failure,
        );
        return false;
      },
    );
  }

  /// 完了したTodoを全て削除
  Future<bool> deleteCompletedTodos() async {
    state = state.copyWith(isDeleting: true, failure: null);

    final result = await _todoService.deleteCompletedTodos();

    return result.fold(
      onSuccess: (_) {
        final updatedTodos =
            state.todos.where((todo) => !todo.isCompleted).toList();
        final updatedSelectedIds = state.selectedTodoIds.where((id) {
          return state.todos.any((todo) => todo.id == id && !todo.isCompleted);
        }).toList();

        state = state.copyWith(
          todos: updatedTodos,
          selectedTodoIds: updatedSelectedIds,
          isDeleting: false,
        );
        _applyFilters();
        _loadStatistics();
        return true;
      },
      onError: (failure) {
        state = state.copyWith(
          isDeleting: false,
          failure: failure,
        );
        return false;
      },
    );
  }

  /// 全てのTodoを削除
  Future<bool> deleteAllTodos() async {
    state = state.copyWith(isDeleting: true, failure: null);

    final result = await _todoService.deleteAllTodos();

    return result.fold(
      onSuccess: (_) {
        state = state.copyWith(
          todos: [],
          selectedTodoIds: [],
          filteredTodos: [],
          isDeleting: false,
          statistics: null,
        );
        return true;
      },
      onError: (failure) {
        state = state.copyWith(
          isDeleting: false,
          failure: failure,
        );
        return false;
      },
    );
  }

  /// フィルタ設定を更新
  void updateFilterSettings(TodoFilterSettings newSettings) {
    state = state.copyWith(filterSettings: newSettings);
    _applyFilters();
  }

  /// 検索クエリを更新
  void updateSearchQuery(String query) {
    final newSettings = state.filterSettings.copyWith(searchQuery: query);
    updateFilterSettings(newSettings);
  }

  /// フィルタタイプを更新
  void updateFilterType(TodoFilterType filterType) {
    final newSettings = state.filterSettings.copyWith(filterType: filterType);
    updateFilterSettings(newSettings);
  }

  /// ソートタイプを更新
  void updateSortType(TodoSortType sortType) {
    final newSettings = state.filterSettings.copyWith(sortType: sortType);
    updateFilterSettings(newSettings);
  }

  /// フィルタをリセット
  void resetFilters() {
    state = state.copyWith(filterSettings: const TodoFilterSettings());
    _applyFilters();
  }

  /// Todoの選択状態を切り替え
  void toggleTodoSelection(String todoId) {
    final selectedIds = List<String>.from(state.selectedTodoIds);

    if (selectedIds.contains(todoId)) {
      selectedIds.remove(todoId);
    } else {
      selectedIds.add(todoId);
    }

    state = state.copyWith(selectedTodoIds: selectedIds);
  }

  /// 全てのTodoの選択状態を切り替え（表示中のもののみ）
  void toggleAllTodosSelection() {
    if (state.areAllTodosSelected) {
      // 全て選択解除
      state = state.copyWith(selectedTodoIds: []);
    } else {
      // 表示中の全てを選択
      final allDisplayedIds =
          state.filteredTodos.map((todo) => todo.id).toList();
      state = state.copyWith(selectedTodoIds: allDisplayedIds);
    }
  }

  /// 選択をクリア
  void clearSelection() {
    state = state.copyWith(selectedTodoIds: []);
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(failure: null);
  }

  /// フィルタを適用
  void _applyFilters() {
    final filteredTodos = TodoFilterService.complexFilter(
      state.todos,
      filterType: state.filterSettings.filterType,
      sortType: state.filterSettings.sortType,
      searchQuery: state.filterSettings.searchQuery,
      startDate: state.filterSettings.startDate,
      endDate: state.filterSettings.endDate,
      useCreatedAtForDateFilter: state.filterSettings.useCreatedAtForDateFilter,
    );

    state = state.copyWith(filteredTodos: filteredTodos);
  }

  /// 統計情報を読み込み
  Future<void> _loadStatistics() async {
    final result = await _todoService.getTodoStatistics();

    result.when(
      onSuccess: (statistics) {
        state = state.copyWith(statistics: statistics);
      },
      onError: (failure) {
        // 統計情報の取得失敗は重要ではないのでログのみ
        // 実際のアプリではロガーを使用
        print('統計情報の取得に失敗: ${failure.message}');
      },
    );
  }

  /// リフレッシュ（再読み込み）
  Future<void> refresh() async {
    await loadTodos();
  }
}
