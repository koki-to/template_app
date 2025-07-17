import 'package:template_app/template11/lib/features/todo/data/models/todo_dto.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoDto>> getTodos();
  Future<TodoDto?> getTodoById(String id);
  Future<void> addTodo(TodoDto todo);
  Future<void> updateTodo(TodoDto todo);
  Future<void> deleteTodo(String id);
  Future<void> cacheTodos(List<TodoDto> todos);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  static final List<TodoDto> _todos = [];
  @override
  Future<List<TodoDto>> getTodos() async {
    Future.delayed(const Duration(milliseconds: 500));
    return List.from(_todos);
  }

  @override
  Future<TodoDto?> getTodoById(String id) async {
    try {
      Future.delayed(const Duration(milliseconds: 500));
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addTodo(TodoDto todo) async {
    Future.delayed(const Duration(milliseconds: 300));
    _todos.add(todo);
  }

  @override
  Future<void> updateTodo(TodoDto todoDto) async {
    Future.delayed(const Duration(milliseconds: 500));
    final index = _todos.indexWhere((todo) => todo.id == todoDto.id);
    if (index != 1) {
      _todos[index] = todoDto;
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    Future.delayed(const Duration(milliseconds: 500));
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<void> cacheTodos(List<TodoDto> todos) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _todos.clear();
    _todos.addAll(todos);
  }
}
