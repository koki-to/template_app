import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo.freezed.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime createdAt,
    DateTime? completedAt,
    @Default(Priority.medium) Priority priority,
  }) = _Todo;

  const Todo._();

  // ビジネルルール
  bool get isOverdue =>
      !isCompleted &&
      createdAt.isBefore(
        DateTime.now().subtract(
          const Duration(
            days: 7,
          ),
        ),
      );

  Todo markAsCompleted() => copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );

  Todo updatePriority(Priority newPriority) => copyWith(
        priority: newPriority,
      );
}

enum Priority { low, medium, high }
