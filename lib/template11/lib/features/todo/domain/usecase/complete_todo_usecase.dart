import 'package:template_app/template11/lib/core/errors/exceptions.dart';
import 'package:template_app/template11/lib/features/todo/domain/repositories/todo_repository.dart';

class CompleteTodoUseCase {
  const CompleteTodoUseCase({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;

  Future<void> call(String todoId) async {
    final todo = await _todoRepository.getTodoById(todoId);
    if (todo == null) {
      throw const ValidationException(message: 'Todoが見つかりません');
    }
    if (todo.isCompleted) {
      throw const BusinessLogicException(message: '既に完了済みのTodoです');
    }

    final completedTodo = todo.markAsCompleted();

    await _todoRepository.updateTodo(completedTodo);
  }
}
