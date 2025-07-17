import 'package:flutter/material.dart';

import '../../features/todo/presentation/pages/todo_list_page.dart';
import '../../features/todo/presentation/pages/todo_create_page.dart';
import '../../features/todo/presentation/pages/todo_edit_page.dart';
import '../../features/todo/presentation/pages/todo_detail_page.dart';

class AppRouter {
  static const String todoList = '/';
  static const String todoCreate = '/todo/create';
  static const String todoEdit = '/todo/edit';
  static const String todoDetail = '/todo/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case todoList:
        return MaterialPageRoute(
          builder: (_) => const TodoListPage(),
          settings: settings,
        );

      case todoCreate:
        return MaterialPageRoute(
          builder: (_) => const TodoCreatePage(),
          settings: settings,
        );

      case todoEdit:
        final todoId = settings.arguments as String?;
        if (todoId == null) {
          return _errorRoute('Todo ID is required for edit');
        }
        return MaterialPageRoute(
          builder: (_) => TodoEditPage(todoId: todoId),
          settings: settings,
        );

      case todoDetail:
        final todoId = settings.arguments as String?;
        if (todoId == null) {
          return _errorRoute('Todo ID is required for detail');
        }
        return MaterialPageRoute(
          builder: (_) => TodoDetailPage(todoId: todoId),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('エラー'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'ページが見つかりません',
                style: Theme.of(_).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(_).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(_).pushNamedAndRemoveUntil(
                    todoList,
                    (route) => false,
                  );
                },
                child: const Text('ホームに戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}