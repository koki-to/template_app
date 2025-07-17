import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodoById(String id);
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<List<Todo>> getTodosByStatus(bool isCompleted);
}
