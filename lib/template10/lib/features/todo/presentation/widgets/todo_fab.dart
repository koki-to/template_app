import 'package:flutter/material.dart';

class TodoFab extends StatelessWidget {
  const TodoFab({
    super.key,
    required this.onCreateTodo,
  });

  final VoidCallback onCreateTodo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton.extended(
      onPressed: onCreateTodo,
      icon: const Icon(Icons.add),
      label: const Text('新しいTodo'),
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      elevation: 4,
      tooltip: 'Todo作成',
    );
  }
}