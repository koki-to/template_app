import '../domain/entities/todo.dart';

/// Todoのフィルタリングとソート機能を提供するサービス
enum TodoFilterType {
  all,
  completed,
  incomplete,
}

enum TodoSortType {
  createdAtDesc,    // 作成日時降順（新しい順）
  createdAtAsc,     // 作成日時昇順（古い順）
  updatedAtDesc,    // 更新日時降順
  updatedAtAsc,     // 更新日時昇順
  titleAsc,         // タイトル昇順
  titleDesc,        // タイトル降順
  completionStatus, // 完了状態順（未完了→完了）
}

class TodoFilterService {
  /// フィルタ条件に基づいてTodoリストをフィルタリング
  static List<Todo> filterTodos(
    List<Todo> todos,
    TodoFilterType filterType,
  ) {
    switch (filterType) {
      case TodoFilterType.all:
        return todos;
      case TodoFilterType.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case TodoFilterType.incomplete:
        return todos.where((todo) => !todo.isCompleted).toList();
    }
  }

  /// ソート条件に基づいてTodoリストをソート
  static List<Todo> sortTodos(
    List<Todo> todos,
    TodoSortType sortType,
  ) {
    final sortedTodos = List<Todo>.from(todos);

    switch (sortType) {
      case TodoSortType.createdAtDesc:
        sortedTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TodoSortType.createdAtAsc:
        sortedTodos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TodoSortType.updatedAtDesc:
        sortedTodos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case TodoSortType.updatedAtAsc:
        sortedTodos.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case TodoSortType.titleAsc:
        sortedTodos.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case TodoSortType.titleDesc:
        sortedTodos.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case TodoSortType.completionStatus:
        sortedTodos.sort((a, b) {
          // 未完了を先に、完了を後に
          if (a.isCompleted == b.isCompleted) {
            return b.createdAt.compareTo(a.createdAt); // 同じ状態なら新しい順
          }
          return a.isCompleted ? 1 : -1;
        });
        break;
    }

    return sortedTodos;
  }

  /// フィルタリングとソートを同時に実行
  static List<Todo> filterAndSortTodos(
    List<Todo> todos,
    TodoFilterType filterType,
    TodoSortType sortType,
  ) {
    final filteredTodos = filterTodos(todos, filterType);
    return sortTodos(filteredTodos, sortType);
  }

  /// 日付範囲でフィルタリング
  static List<Todo> filterByDateRange(
    List<Todo> todos, {
    DateTime? startDate,
    DateTime? endDate,
    bool useCreatedAt = true, // true: createdAt, false: updatedAt
  }) {
    return todos.where((todo) {
      final targetDate = useCreatedAt ? todo.createdAt : todo.updatedAt;
      
      if (startDate != null && targetDate.isBefore(startDate)) {
        return false;
      }
      
      if (endDate != null && targetDate.isAfter(endDate)) {
        return false;
      }
      
      return true;
    }).toList();
  }

  /// 今日作成されたTodoのみを取得
  static List<Todo> getTodayCreatedTodos(List<Todo> todos) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    return todos.where((todo) {
      return todo.createdAt.isAfter(todayStart) && 
             todo.createdAt.isBefore(todayEnd);
    }).toList();
  }

  /// 今週作成されたTodoのみを取得
  static List<Todo> getThisWeekCreatedTodos(List<Todo> todos) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    
    return todos.where((todo) {
      return todo.createdAt.isAfter(weekStartDate);
    }).toList();
  }

  /// 検索キーワードでフィルタリング（タイトルと説明の両方を検索）
  static List<Todo> searchTodos(
    List<Todo> todos,
    String query, {
    bool caseSensitive = false,
  }) {
    if (query.trim().isEmpty) {
      return todos;
    }

    final searchQuery = caseSensitive ? query.trim() : query.trim().toLowerCase();
    
    return todos.where((todo) {
      final title = caseSensitive ? todo.title : todo.title.toLowerCase();
      final description = caseSensitive ? todo.description : todo.description.toLowerCase();
      
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();
  }

  /// 複合条件でのフィルタリング
  static List<Todo> complexFilter(
    List<Todo> todos, {
    TodoFilterType? filterType,
    TodoSortType? sortType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool useCreatedAtForDateFilter = true,
  }) {
    var result = todos;

    // 検索フィルタ
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      result = searchTodos(result, searchQuery);
    }

    // 日付範囲フィルタ
    if (startDate != null || endDate != null) {
      result = filterByDateRange(
        result,
        startDate: startDate,
        endDate: endDate,
        useCreatedAt: useCreatedAtForDateFilter,
      );
    }

    // 状態フィルタ
    if (filterType != null) {
      result = filterTodos(result, filterType);
    }

    // ソート
    if (sortType != null) {
      result = sortTodos(result, sortType);
    }

    return result;
  }
}

/// フィルタ設定を保持するクラス
class TodoFilterSettings {
  const TodoFilterSettings({
    this.filterType = TodoFilterType.all,
    this.sortType = TodoSortType.createdAtDesc,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
    this.useCreatedAtForDateFilter = true,
  });

  final TodoFilterType filterType;
  final TodoSortType sortType;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool useCreatedAtForDateFilter;

  /// フィルタ設定をコピー
  TodoFilterSettings copyWith({
    TodoFilterType? filterType,
    TodoSortType? sortType,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool? useCreatedAtForDateFilter,
  }) {
    return TodoFilterSettings(
      filterType: filterType ?? this.filterType,
      sortType: sortType ?? this.sortType,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      useCreatedAtForDateFilter: useCreatedAtForDateFilter ?? this.useCreatedAtForDateFilter,
    );
  }

  /// フィルタがデフォルト設定かどうか
  bool get isDefault {
    return filterType == TodoFilterType.all &&
           sortType == TodoSortType.createdAtDesc &&
           searchQuery.isEmpty &&
           startDate == null &&
           endDate == null;
  }

  /// フィルタ設定をリセット
  TodoFilterSettings reset() {
    return const TodoFilterSettings();
  }
}