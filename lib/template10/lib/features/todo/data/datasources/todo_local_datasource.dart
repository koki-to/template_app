import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:template_app/template10/lib/core/utils/failure_classes.dart';
import 'package:template_app/template10/lib/features/todo/data/models/sqlite_utils.dart';
import 'package:template_app/template10/lib/features/todo/data/models/todo_model.dart';
import 'package:uuid/uuid.dart';

import 'database_helper.dart';

/// データソースのProvider
final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  return TodoLocalDataSource();
});

// ローカルデータソース（SQLite）でのTodo操作を担当
class TodoLocalDataSource {
  static const String _tableName = 'todos';
  static const Uuid _uuid = Uuid();

  /// 全てのTodoを取得
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'created_at DESC',
      );

      return maps
          .map((map) => SqliteUtils.todoModelFromSqliteMap(map))
          .toList();
    } catch (e) {
      throw DatabaseFailure('データの取得に失敗しました: ${e.toString()}');
    }
  }

  /// IDでTodoを取得
  Future<TodoModel?> getTodoById(String id) async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) {
        return null;
      }

      return SqliteUtils.todoModelFromSqliteMap(maps.first);
    } catch (e) {
      throw DatabaseFailure('データの取得に失敗しました: ${e.toString()}');
    }
  }

  /// 新しいTodoを作成
  Future<TodoModel> createTodo(TodoModel todo) async {
    try {
      final db = await DatabaseHelper.database;

      // UUIDを生成
      final todoWithId = todo.copyWith(id: _uuid.v4());

      final result = await db.insert(
        _tableName,
        SqliteUtils.todoModelToSqliteMap(todoWithId),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      if (result == 0) {
        throw DatabaseFailure.insert();
      }

      return todoWithId;
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw DatabaseFailure('データの挿入に失敗しました: ${e.toString()}');
    }
  }

  /// Todoを更新
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final db = await DatabaseHelper.database;

      final result = await db.update(
        _tableName,
        SqliteUtils.todoModelToSqliteMap(todo),
        where: 'id = ?',
        whereArgs: [todo.id],
      );

      if (result == 0) {
        throw DatabaseFailure('指定されたTodoが見つかりません');
      }

      return todo;
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw DatabaseFailure('データの更新に失敗しました: ${e.toString()}');
    }
  }

  /// Todoを削除
  Future<void> deleteTodo(String id) async {
    try {
      final db = await DatabaseHelper.database;

      final result = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result == 0) {
        throw DatabaseFailure('指定されたTodoが見つかりません');
      }
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw DatabaseFailure('データの削除に失敗しました: ${e.toString()}');
    }
  }

  /// 完了したTodoのみを取得
  Future<List<TodoModel>> getCompletedTodos() async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'is_completed = ?',
        whereArgs: [1],
        orderBy: 'updated_at DESC',
      );

      return maps
          .map((map) => SqliteUtils.todoModelFromSqliteMap(map))
          .toList();
    } catch (e) {
      throw DatabaseFailure('データの取得に失敗しました: ${e.toString()}');
    }
  }

  /// 未完了のTodoのみを取得
  Future<List<TodoModel>> getIncompleteTodos() async {
    try {
      final db = await DatabaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'is_completed = ?',
        whereArgs: [0],
        orderBy: 'created_at DESC',
      );

      return maps
          .map((map) => SqliteUtils.todoModelFromSqliteMap(map))
          .toList();
    } catch (e) {
      throw DatabaseFailure('データの取得に失敗しました: ${e.toString()}');
    }
  }

  /// 複数のTodoを一括削除
  Future<void> deleteTodos(List<String> ids) async {
    if (ids.isEmpty) return;

    try {
      final db = await DatabaseHelper.database;

      // トランザクションで一括削除
      await db.transaction((txn) async {
        for (final id in ids) {
          await txn.delete(
            _tableName,
            where: 'id = ?',
            whereArgs: [id],
          );
        }
      });
    } catch (e) {
      throw DatabaseFailure('データの一括削除に失敗しました: ${e.toString()}');
    }
  }

  /// 全てのTodoを削除
  Future<void> deleteAllTodos() async {
    try {
      final db = await DatabaseHelper.database;
      await db.delete(_tableName);
    } catch (e) {
      throw DatabaseFailure('全データの削除に失敗しました: ${e.toString()}');
    }
  }

  /// 検索機能（タイトルまたは説明で部分一致）
  Future<List<TodoModel>> searchTodos(String query) async {
    if (query.trim().isEmpty) {
      return getAllTodos();
    }

    try {
      final db = await DatabaseHelper.database;
      final searchQuery = '%${query.trim()}%';

      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: [searchQuery, searchQuery],
        orderBy: 'created_at DESC',
      );

      return maps
          .map((map) => SqliteUtils.todoModelFromSqliteMap(map))
          .toList();
    } catch (e) {
      throw DatabaseFailure('データの検索に失敗しました: ${e.toString()}');
    }
  }

  /// データベースの状態を確認（デバッグ用）
  Future<int> getTodoCount() async {
    try {
      final db = await DatabaseHelper.database;
      final result =
          await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
      return result.first['count'] as int;
    } catch (e) {
      throw DatabaseFailure('データ数の取得に失敗しました: ${e.toString()}');
    }
  }

  /// 完了率を取得（統計用）
  Future<double> getCompletionRate() async {
    try {
      final db = await DatabaseHelper.database;

      // 全体数
      final totalResult =
          await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
      final totalCount = totalResult.first['count'] as int;

      if (totalCount == 0) return 0.0;

      // 完了数
      final completedResult = await db.rawQuery(
          'SELECT COUNT(*) as count FROM $_tableName WHERE is_completed = 1');
      final completedCount = completedResult.first['count'] as int;

      return completedCount / totalCount;
    } catch (e) {
      throw DatabaseFailure('完了率の取得に失敗しました: ${e.toString()}');
    }
  }
}
