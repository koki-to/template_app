import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';
import 'package:template_app/template11/lib/features/todo/domain/repositories/todo_repository.dart';

class GetTodosUseCase {
  GetTodosUseCase({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;
  final TodoRepository _todoRepository;

  Future<List<Todo>> call() async {
    return await _todoRepository.getTodos();
  }

  Future<List<Todo>> getActiveTodos() async {
    return await _todoRepository.getTodosByStatus(false);
  }

  Future<List<Todo>> getCompletedTodos() async {
    return await _todoRepository.getTodosByStatus(true);
  }
}
