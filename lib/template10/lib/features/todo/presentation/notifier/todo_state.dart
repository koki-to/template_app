import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_app/template10/lib/core/utils/failure_classes.dart';
import 'package:template_app/template10/lib/features/todo/service/todo_filter_service.dart';
import 'package:template_app/template10/lib/features/todo/service/todo_service.dart';

import '../../domain/entities/todo.dart';

part 'todo_state.freezed.dart';

@freezed
abstract class TodoState with _$TodoState {
  const factory TodoState({
    @Default([]) List<Todo> todos,
    @Default([]) List<Todo> filteredTodos,
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    @Default(false) bool isUpdating,
    @Default(false) bool isDeleting,
    @Default(TodoFilterSettings()) TodoFilterSettings filterSettings,
    @Default([]) List<String> selectedTodoIds,
    Failure? failure,
    TodoStatistics? statistics,
  }) = _TodoState;

  const TodoState._();

  /// エラーがあるかどうか
  bool get hasError => failure != null;

  /// 何らかの処理中かどうか
  bool get isProcessing => isLoading || isCreating || isUpdating || isDeleting;

  /// 選択されたTodoがあるかどうか
  bool get hasSelectedTodos => selectedTodoIds.isNotEmpty;

  /// 選択されたTodo数
  int get selectedCount =>
      selectedTodoIds.isNotEmpty ? selectedTodoIds.length : 0;

  /// 特定のTodoが選択されているかどうか
  bool isTodoSelected(String todoId) => selectedTodoIds.contains(todoId);

  /// 全てのTodoが選択されているかどうか（表示中のもののみ）
  bool get areAllTodosSelected {
    if (filteredTodos.isEmpty) return false;
    return filteredTodos.every((todo) => selectedTodoIds.contains(todo.id));
  }

  /// フィルタが適用されているかどうか
  bool get isFiltered => !filterSettings.isDefault;

  /// 検索中かどうか
  bool get isSearching => filterSettings.searchQuery.isNotEmpty;

  /// エラーメッセージを取得
  String? get errorMessage => failure?.message;
}
