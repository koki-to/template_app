import 'package:template_app/template11/lib/core/errors/exceptions.dart';
import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';
import 'package:template_app/template11/lib/features/todo/domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class AddTodoUseCase {
  const AddTodoUseCase({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;

  Future<void> call({
    required String title,
    required String description,
    Priority priority = Priority.medium,
  }) async {
    if (title.trim().isEmpty) {
      throw const ValidationException(message: 'タイトルを入力してください');
    }

    if (title.length > 100) {
      throw const ValidationException(message: 'タイトルは100文字以内で入力してください');
    }
    if (description.length > 500) {
      throw const ValidationException(message: '説明は500文字以内で入力してください');
    }

    final todo = Todo(
      id: _genereteId(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: priority,
    );

    await _todoRepository.addTodo(todo);
  }

  String _genereteId() {
    return const Uuid().v4();
  }
}
