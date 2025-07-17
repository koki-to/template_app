import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';

part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

@freezed
abstract class TodoDto with _$TodoDto {
  const factory TodoDto({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required String createdAt,
    String? completedAt,
    @Default('medium') String priority,
  }) = _TodoDto;

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);

  const TodoDto._();

  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: DateTime.parse(createdAt),
      priority: Priority.values.firstWhere(
        (p) => p.name == priority,
        orElse: () => Priority.medium,
      ),
    );
  }

  static TodoDto fromEntity(Todo todo) {
    return TodoDto(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt.toIso8601String(),
      completedAt: todo.completedAt?.toIso8601String(),
      priority: todo.priority.name,
    );
  }
}
