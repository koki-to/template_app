import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template11/lib/features/todo/data/datasources/providers.dart';
import 'package:template_app/template11/lib/features/todo/domain/entities/todo.dart';
import 'package:template_app/template11/lib/features/todo/domain/usecase/add_todo_usecase.dart';
import 'package:template_app/template11/lib/features/todo/domain/usecase/complete_todo_usecase.dart';
import 'package:template_app/template11/lib/features/todo/domain/usecase/get_todos_usecase.dart';

final todoListNotifierProvider =
    StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>((ref) {
  return TodoListNotifier(
    getTodosUseCase: ref.read(getTodosUseCaseProvider),
    addTodoUseCase: ref.read(addTodoUseCaseProvider),
    completeTodoUseCase: ref.read(completeTodoUseCaseProvider),
  );
});

class TodoListNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoListNotifier({
    required GetTodosUseCase getTodosUseCase,
    required AddTodoUseCase addTodoUseCase,
    required CompleteTodoUseCase completeTodoUseCase,
  })  : _getTodosUseCase = getTodosUseCase,
        _addTodoUseCase = addTodoUseCase,
        _completeTodoUseCase = completeTodoUseCase,
        super(const AsyncValue.loading()) {
    _init();
  }

  final GetTodosUseCase _getTodosUseCase;
  final AddTodoUseCase _addTodoUseCase;
  final CompleteTodoUseCase _completeTodoUseCase;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getTodosUseCase.call());
  }

  Future<void> addTodo({
    required String title,
    required String description,
    Priority priority = Priority.medium,
  }) async {
    try {
      await _addTodoUseCase.call(
        title: title,
        description: description,
        priority: priority,
      );
      await _init();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> completeTodo(String id) async {
    try {
      await _completeTodoUseCase.call(id);
      await _init(); // リロード
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _init();
  }
}
