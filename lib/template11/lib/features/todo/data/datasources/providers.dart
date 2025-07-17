// Data Sources
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template11/lib/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:template_app/template11/lib/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:template_app/template11/lib/features/todo/domain/repositories/todo_repository.dart';
import 'package:template_app/template11/lib/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:template_app/template11/lib/features/todo/domain/usecase/complete_todo_usecase.dart';
import 'package:template_app/template11/lib/features/todo/domain/usecase/get_todos_usecase.dart';

final todoLocalDataSourceProvider =
    Provider.autoDispose<TodoLocalDataSource>((ref) {
  return TodoLocalDataSourceImpl();
});

// Repositories
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(
    todoLocalDataSource: ref.read(todoLocalDataSourceProvider),
  );
});

// Use Cases
final getTodosUseCaseProvider = Provider.autoDispose<GetTodosUseCase>((ref) {
  return GetTodosUseCase(todoRepository: ref.read(todoRepositoryProvider));
});

final addTodoUseCaseProvider = Provider.autoDispose<AddTodoUseCase>((ref) {
  return AddTodoUseCase(todoRepository: ref.read(todoRepositoryProvider));
});

final completeTodoUseCaseProvider =
    Provider.autoDispose<CompleteTodoUseCase>((ref) {
  return CompleteTodoUseCase(todoRepository: ref.read(todoRepositoryProvider));
});
