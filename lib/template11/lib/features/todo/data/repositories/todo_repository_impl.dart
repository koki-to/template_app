import 'package:template_app/template11/lib/core/errors/exceptions.dart';
import 'package:template_app/template11/lib/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:template_app/template11/lib/features/todo/data/models/todo_dto.dart';
import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';
import 'package:template_app/template11/lib/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl({required TodoLocalDataSource todoLocalDataSource})
      : _todoLocalDataSource = todoLocalDataSource;

  final TodoLocalDataSource _todoLocalDataSource;

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final todoDtoList = await _todoLocalDataSource.getTodos();
      return todoDtoList.map((todoDto) => todoDto.toEntity()).toList();
    } catch (e) {
      throw DataException(message: 'Todoの取得に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    try {
      final todoDto = TodoDto.fromEntity(todo);
      await _todoLocalDataSource.addTodo(todoDto);
    } catch (e) {
      throw DataException(message: 'Todoの追加に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await _todoLocalDataSource.deleteTodo(id);
    } catch (e) {
      throw DataException(message: 'Todoの削除に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    try {
      final todoDto = await _todoLocalDataSource.getTodoById(id);
      return todoDto?.toEntity();
    } catch (e) {
      throw DataException(message: 'Todoの取得に失敗しました: ${e.toString()}');
    }
  }

  @override
  Future<List<Todo>> getTodosByStatus(bool isCompleted) async {
    final todos = await getTodos();
    return todos.where((todo) => todo.isCompleted == isCompleted).toList();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      final todoDto = TodoDto.fromEntity(todo);
      await _todoLocalDataSource.updateTodo(todoDto);
    } catch (e) {
      throw DataException(message: 'Todoの更新に失敗しました: ${e.toString()}');
    }
  }
}
