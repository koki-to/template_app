import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template11/lib/features/todo/presentation/providers/todo_list_provider.dart';
import 'package:template_app/template11/lib/features/todo/presentation/widgets/add_todo_dialog.dart';
import 'package:template_app/template11/lib/features/todo/presentation/widgets/todo_tile.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsyncValue = ref.watch(todoListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(todoListNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: todosAsyncValue.when(
        data: (todos) => todos.isEmpty
            ? const Center(
                child: Text(
                  'No todos yet!\nTap + to add your first todo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) => TodoTile(
                  todo: todos[index],
                  onToggle: () => ref
                      .read(todoListNotifierProvider.notifier)
                      .completeTodo(todos[index].id),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(todoListNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(
        onAdd: (title, description, priority) {
          ref.read(todoListNotifierProvider.notifier).addTodo(
                title: title,
                description: description,
                priority: priority,
              );
        },
      ),
    );
  }
}
