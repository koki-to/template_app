import '../../../../core/utils/result.dart';
import '../entities/todo.dart';

/// TodoリポジトリのContract（抽象クラス）
abstract class TodoRepository {
  /// 全てのTodoを取得
  Future<Result<List<Todo>>> getAllTodos();

  /// IDでTodoを取得
  Future<Result<Todo>> getTodoById(String id);

  /// 新しいTodoを作成
  Future<Result<Todo>> createTodo(Todo todo);

  /// Todoを更新
  Future<Result<Todo>> updateTodo(Todo todo);

  /// Todoを削除
  Future<Result<void>> deleteTodo(String id);

  /// 完了したTodoのみを取得
  Future<Result<List<Todo>>> getCompletedTodos();

  /// 未完了のTodoのみを取得
  Future<Result<List<Todo>>> getIncompleteTodos();

  /// 複数のTodoを一括削除
  Future<Result<void>> deleteTodos(List<String> ids);

  /// 全てのTodoを削除
  Future<Result<void>> deleteAllTodos();

  /// 検索機能（タイトルまたは説明で）
  Future<Result<List<Todo>>> searchTodos(String query);
}
