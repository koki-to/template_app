import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  const Todo._();

  /// 新しいTodoを作成
  factory Todo.create({
    required String title,
    required String description,
  }) {
    final now = DateTime.now();
    return Todo(
      id: '', // UUIDはRepositoryで生成
      title: title,
      description: description,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Todoを完了/未完了に切り替え
  Todo toggleCompleted() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Todoの内容を更新
  Todo updateContent({
    String? title,
    String? description,
  }) {
    return copyWith(
      title: title ?? this.title,
      description: description ?? this.description,
      updatedAt: DateTime.now(),
    );
  }

  /// バリデーション
  bool get isValidTitle => title.trim().isNotEmpty;
  bool get isValidDescription => description.trim().isNotEmpty;
  bool get isValid => isValidTitle && isValidDescription;
}
