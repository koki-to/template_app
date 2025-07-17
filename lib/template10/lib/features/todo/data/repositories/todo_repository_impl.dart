import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/core/utils/failure_classes.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

/// リポジトリのProvider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dataSource = ref.watch(todoLocalDataSourceProvider);
  return TodoRepositoryImpl(dataSource);
});

/// TodoRepositoryの具象実装クラス
class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._localDataSource);

  final TodoLocalDataSource _localDataSource;

  @override
  Future<Result<List<Todo>>> getAllTodos() async {
    try {
      final todoModels = await _localDataSource.getAllTodos();
      final todos = todoModels.map((model) => model.toEntity()).toList();
      return Success(todos);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Todo>> getTodoById(String id) async {
    try {
      // IDのバリデーション
      if (id.trim().isEmpty) {
        return Error(ValidationFailure.invalidId());
      }

      final todoModel = await _localDataSource.getTodoById(id);

      if (todoModel == null) {
        return Error(ValidationFailure.todoNotFound());
      }

      return Success(todoModel.toEntity());
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } on ValidationFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Todo>> createTodo(Todo todo) async {
    try {
      // バリデーション
      if (!todo.isValidTitle) {
        return Error(ValidationFailure.emptyTitle());
      }
      if (!todo.isValidDescription) {
        return Error(ValidationFailure.emptyDescription());
      }

      final todoModel = TodoModel.fromEntity(todo);
      final createdModel = await _localDataSource.createTodo(todoModel);

      return Success(createdModel.toEntity());
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } on ValidationFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Todo>> updateTodo(Todo todo) async {
    try {
      // バリデーション
      if (todo.id.trim().isEmpty) {
        return Error(ValidationFailure.invalidId());
      }
      if (!todo.isValidTitle) {
        return Error(ValidationFailure.emptyTitle());
      }
      if (!todo.isValidDescription) {
        return Error(ValidationFailure.emptyDescription());
      }

      // 存在確認
      final existingTodo = await _localDataSource.getTodoById(todo.id);
      if (existingTodo == null) {
        return Error(ValidationFailure.todoNotFound());
      }

      final todoModel = TodoModel.fromEntity(todo);
      final updatedModel = await _localDataSource.updateTodo(todoModel);

      return Success(updatedModel.toEntity());
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } on ValidationFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteTodo(String id) async {
    try {
      // IDのバリデーション
      if (id.trim().isEmpty) {
        return Error(ValidationFailure.invalidId());
      }

      // 存在確認
      final existingTodo = await _localDataSource.getTodoById(id);
      if (existingTodo == null) {
        return Error(ValidationFailure.todoNotFound());
      }

      await _localDataSource.deleteTodo(id);
      return const Success(null);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } on ValidationFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Todo>>> getCompletedTodos() async {
    try {
      final todoModels = await _localDataSource.getCompletedTodos();
      final todos = todoModels.map((model) => model.toEntity()).toList();
      return Success(todos);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Todo>>> getIncompleteTodos() async {
    try {
      final todoModels = await _localDataSource.getIncompleteTodos();
      final todos = todoModels.map((model) => model.toEntity()).toList();
      return Success(todos);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteTodos(List<String> ids) async {
    try {
      // 空のリストチェック
      if (ids.isEmpty) {
        return const Success(null);
      }

      // IDのバリデーション
      for (final id in ids) {
        if (id.trim().isEmpty) {
          return Error(ValidationFailure.invalidId());
        }
      }

      await _localDataSource.deleteTodos(ids);
      return const Success(null);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } on ValidationFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteAllTodos() async {
    try {
      await _localDataSource.deleteAllTodos();
      return const Success(null);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Todo>>> searchTodos(String query) async {
    try {
      final todoModels = await _localDataSource.searchTodos(query);
      final todos = todoModels.map((model) => model.toEntity()).toList();
      return Success(todos);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  /// 統計情報を取得（追加機能）
  Future<Result<int>> getTodoCount() async {
    try {
      final count = await _localDataSource.getTodoCount();
      return Success(count);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }

  /// 完了率を取得（追加機能）
  Future<Result<double>> getCompletionRate() async {
    try {
      final rate = await _localDataSource.getCompletionRate();
      return Success(rate);
    } on DatabaseFailure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(DatabaseFailure('予期しないエラーが発生しました: ${e.toString()}'));
    }
  }
}
