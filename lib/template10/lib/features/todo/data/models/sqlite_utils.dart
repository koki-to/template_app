import 'todo_model.dart';

/// SQLite用のユーティリティクラス
class SqliteUtils {
  /// TodoModelをSQLite用のMapに変換
  static Map<String, dynamic> todoModelToSqliteMap(TodoModel model) {
    return {
      'id': model.id,
      'title': model.title,
      'description': model.description,
      'is_completed': model.isCompleted ? 1 : 0, // boolean → integer
      'created_at': model.createdAt,
      'updated_at': model.updatedAt,
    };
  }

  /// SQLiteのMapからTodoModelを作成
  static TodoModel todoModelFromSqliteMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: (map['is_completed'] as int) == 1, // integer → boolean
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }
}