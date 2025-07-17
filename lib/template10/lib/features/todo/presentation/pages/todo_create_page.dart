import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/template10/lib/features/todo/presentation/notifier/todo_notifier.dart';

import '../widgets/todo_form.dart';

class TodoCreatePage extends ConsumerWidget {
  const TodoCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoNotifierProvider.notifier);
    final todoState = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('新しいTodo'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: TodoForm(
        isCreating: true,
        isLoading: todoState.isCreating,
        onSubmit: (title, description) async {
          final success = await todoNotifier.createTodo(
            title: title,
            description: description,
          );

          if (success && context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Todoを作成しました'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (context.mounted && todoState.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(todoState.errorMessage ?? '作成に失敗しました'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
