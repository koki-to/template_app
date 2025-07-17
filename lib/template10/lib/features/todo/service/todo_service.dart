import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/core/utils/failure_classes.dart';
import 'package:template_app/template10/lib/features/todo/data/repositories/todo_repository_impl.dart';

import '../../../core/utils/result.dart';
import '../domain/entities/todo.dart';
import '../domain/repositories/todo_repository.dart';
import 'validators/todo_validator.dart';

/// サービスのProvider
final todoServiceProvider = Provider<TodoService>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoService(repository);
});

/// Todoのビジネスロジックを担当するサービスクラス
class TodoService {
  const TodoService(this._repository);

  final TodoRepository _repository;

  /// 全てのTodoを取得
  Future<Result<List<Todo>>> getAllTodos() async {
    return await _repository.getAllTodos();
  }

  /// IDでTodoを取得
  Future<Result<Todo>> getTodoById(String id) async {
    // バリデーション
    final idValidation = TodoValidator.validateId(id);
    if (idValidation.isError) {
      return Error(idValidation.failure!);
    }

    return await _repository.getTodoById(idValidation.data!);
  }

  /// 新しいTodoを作成
  Future<Result<Todo>> createTodo({
    required String title,
    required String description,
  }) async {
    // バリデーション
    final validation = TodoValidator.validateTodoCreation(
      title: title,
      description: description,
    );

    if (validation.isError) {
      return Error(validation.failure!);
    }

    final validatedData = validation.data!;

    // ビジネスルール: 同じタイトルのTodoが既に存在しないかチェック
    final duplicateCheck = await _checkDuplicateTitle(validatedData['title']!);
    if (duplicateCheck.isError) {
      return Error(duplicateCheck.failure!);
    }

    // Todoエンティティを作成
    final todo = Todo.create(
      title: validatedData['title']!,
      description: validatedData['description']!,
    );

    return await _repository.createTodo(todo);
  }

  /// Todoを更新
  Future<Result<Todo>> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    // バリデーション
    final validation = TodoValidator.validateTodoUpdate(
      id: id,
      title: title,
      description: description,
    );

    if (validation.isError) {
      return Error(validation.failure!);
    }

    final validatedData = validation.data!;

    // 既存のTodoを取得
    final existingTodoResult =
        await _repository.getTodoById(validatedData['id']!);
    if (existingTodoResult.isError) {
      return Error(existingTodoResult.failure!);
    }

    final existingTodo = existingTodoResult.data!;

    // ビジネスルール: タイトルが変更された場合、重複チェック
    if (existingTodo.title != validatedData['title']) {
      final duplicateCheck =
          await _checkDuplicateTitle(validatedData['title']!);
      if (duplicateCheck.isError) {
        return Error(duplicateCheck.failure!);
      }
    }

    // Todoを更新
    final updatedTodo = existingTodo.updateContent(
      title: validatedData['title'],
      description: validatedData['description'],
    );

    return await _repository.updateTodo(updatedTodo);
  }

  /// Todoの完了状態を切り替え
  Future<Result<Todo>> toggleTodoCompletion(String id) async {
    // IDバリデーション
    final idValidation = TodoValidator.validateId(id);
    if (idValidation.isError) {
      return Error(idValidation.failure!);
    }

    // 既存のTodoを取得
    final todoResult = await _repository.getTodoById(idValidation.data!);
    if (todoResult.isError) {
      return Error(todoResult.failure!);
    }

    final todo = todoResult.data!;

    // 完了状態を切り替え
    final toggledTodo = todo.toggleCompleted();

    return await _repository.updateTodo(toggledTodo);
  }

  /// Todoを削除
  Future<Result<void>> deleteTodo(String id) async {
    // バリデーション
    final idValidation = TodoValidator.validateId(id);
    if (idValidation.isError) {
      return Error(idValidation.failure!);
    }

    return await _repository.deleteTodo(idValidation.data!);
  }

  /// 複数のTodoを一括削除
  Future<Result<void>> deleteTodos(List<String> ids) async {
    // バリデーション
    final idsValidation = TodoValidator.validateIds(ids);
    if (idsValidation.isError) {
      return Error(idsValidation.failure!);
    }

    return await _repository.deleteTodos(idsValidation.data!);
  }

  /// 完了したTodoを全て削除
  Future<Result<void>> deleteCompletedTodos() async {
    // 完了したTodoを取得
    final completedTodosResult = await _repository.getCompletedTodos();
    if (completedTodosResult.isError) {
      return Error(completedTodosResult.failure!);
    }

    final completedTodos = completedTodosResult.data!;

    if (completedTodos.isEmpty) {
      return Error(ValidationFailure('削除する完了済みTodoがありません'));
    }

    final ids = completedTodos.map((todo) => todo.id).toList();
    return await _repository.deleteTodos(ids);
  }

  /// 全てのTodoを削除
  Future<Result<void>> deleteAllTodos() async {
    return await _repository.deleteAllTodos();
  }

  /// 完了したTodoのみを取得
  Future<Result<List<Todo>>> getCompletedTodos() async {
    return await _repository.getCompletedTodos();
  }

  /// 未完了のTodoのみを取得
  Future<Result<List<Todo>>> getIncompleteTodos() async {
    return await _repository.getIncompleteTodos();
  }

  /// Todoを検索
  Future<Result<List<Todo>>> searchTodos(String query) async {
    // バリデーション
    final queryValidation = TodoValidator.validateSearchQuery(query);
    if (queryValidation.isError) {
      return Error(queryValidation.failure!);
    }

    return await _repository.searchTodos(queryValidation.data!);
  }

  /// Todo統計情報を取得
  Future<Result<TodoStatistics>> getTodoStatistics() async {
    // 全てのTodoを取得
    final allTodosResult = await _repository.getAllTodos();
    if (allTodosResult.isError) {
      return Error(allTodosResult.failure!);
    }

    final allTodos = allTodosResult.data!;

    final totalCount = allTodos.length;
    final completedCount = allTodos.where((todo) => todo.isCompleted).length;
    final incompleteCount = totalCount - completedCount;
    final completionRate = totalCount > 0 ? completedCount / totalCount : 0.0;

    // 今日作成されたTodo数
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final todayCreatedCount = allTodos.where((todo) {
      return todo.createdAt.isAfter(todayStart) &&
          todo.createdAt.isBefore(todayEnd);
    }).length;

    final statistics = TodoStatistics(
      totalCount: totalCount,
      completedCount: completedCount,
      incompleteCount: incompleteCount,
      completionRate: completionRate,
      todayCreatedCount: todayCreatedCount,
    );

    return Success(statistics);
  }

  /// プライベートメソッド: タイトル重複チェック
  Future<Result<void>> _checkDuplicateTitle(String title) async {
    final allTodosResult = await _repository.getAllTodos();
    if (allTodosResult.isError) {
      return Error(allTodosResult.failure!);
    }

    final allTodos = allTodosResult.data!;
    final isDuplicate =
        allTodos.any((todo) => todo.title.toLowerCase() == title.toLowerCase());

    if (isDuplicate) {
      return Error(ValidationFailure('同じタイトルのTodoが既に存在します'));
    }

    return const Success(null);
  }
}

/// Todo統計情報を表すクラス
class TodoStatistics {
  const TodoStatistics({
    required this.totalCount,
    required this.completedCount,
    required this.incompleteCount,
    required this.completionRate,
    required this.todayCreatedCount,
  });

  final int totalCount;
  final int completedCount;
  final int incompleteCount;
  final double completionRate;
  final int todayCreatedCount;

  /// 完了率をパーセンテージで取得
  double get completionPercentage => completionRate * 100;

  /// 統計情報が空かどうか
  bool get isEmpty => totalCount == 0;

  @override
  String toString() {
    return 'TodoStatistics('
        'total: $totalCount, '
        'completed: $completedCount, '
        'incomplete: $incompleteCount, '
        'rate: ${completionPercentage.toStringAsFixed(1)}%, '
        'todayCreated: $todayCreatedCount'
        ')';
  }
}
