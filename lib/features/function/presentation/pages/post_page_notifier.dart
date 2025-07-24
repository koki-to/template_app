// lib/presentation/screens/posts/posts_screen_state.dart
// Posts画面専用のState定義

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template_app/core/errors/app_exception.dart';
import 'package:template_app/core/utils/result.dart';
import 'package:template_app/features/function/data/models/post_model.dart';
import 'package:template_app/features/function/domain/service/post_service.dart';
import 'package:template_app/features/function/presentation/providers/post_providers.dart';

part 'post_page_notifier.freezed.dart';

// ===============================
// 📊 PostsScreenState：画面状態の定義
// ===============================

/// Posts画面の状態を管理するStateクラス
///
/// 【現場での一画面一State設計】
/// - 画面固有の状態をすべて含む
/// - UI操作に必要な状態を網羅
/// - 複雑な状態遷移をわかりやすく管理
@freezed
sealed class PostPageState with _$PostPageState {
  const factory PostPageState({
    // === データ状態 ===
    @Default([]) List<Post> posts,
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    AppException? error,

    // === 検索機能 ===
    @Default('') String searchKeyword,
    @Default([]) List<Post> searchResults,
    @Default(false) bool isSearching,
    @Default(false) bool showSearchResults,

    // === フィルタリング ===
    int? selectedUserId,
    PostLengthCategory? selectedCategory,
    @Default(SortType.newest) SortType sortType,

    // === UI状態 ===
    @Default(PostsViewMode.list) PostsViewMode viewMode,
    @Default(false) bool showFilters,
    @Default(false) bool isSelectionMode,
    @Default({}) Set<int> selectedPostIds,

    // === ページネーション ===
    @Default(0) int currentPage,
    @Default(false) bool hasMorePosts,
    @Default(false) bool isLoadingMore,

    // === 統計・分析 ===
    PostsAnalytics? analytics,
    @Default(false) bool showAnalytics,

    // === 操作状態 ===
    @Default({}) Map<int, bool> deletingPosts, // 削除中の投稿ID
    int? editingPostId, // 編集中の投稿ID

    // === エラー詳細 ===
    @Default(false) bool showErrorDetails,

    // === 最終更新時刻 ===
    DateTime? lastUpdated,
  }) = _PostPageState;
}

/// 表示モード
enum PostsViewMode {
  list, // リスト表示
  grid, // グリッド表示
  compact, // コンパクト表示
}

// ===============================
// 🎯 PostsScreenNotifier：画面ロジック管理
// ===============================

/// Posts画面のロジックを管理するNotifierクラス
///
/// 【現場での一画面一Notifier設計】
/// - 画面固有のロジックをすべて含む
/// - UI操作とビジネスロジックの仲介
/// - 状態変更の一元管理
/// - エラーハンドリングの統一
class PostPageNotifier extends StateNotifier<PostPageState> {
  final PostService _postService;

  PostPageNotifier(this._postService) : super(const PostPageState());

  // ===============================
  // 🔄 初期化・データ読み込み
  // ===============================

  /// 画面初期化
  Future<void> initialize() async {
    await loadPosts();
    await loadAnalytics();
  }

  /// 投稿一覧読み込み
  Future<void> loadPosts({bool forceRefresh = false}) async {
    if (state.isLoading && !forceRefresh) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    final result = await _postService.getAllPosts(forceRefresh: forceRefresh);

    switch (result) {
      case Success(data: final posts):
        state = state.copyWith(
          posts: posts,
          isLoading: false,
          lastUpdated: DateTime.now(),
          currentPage: 0,
          hasMorePosts: posts.length >= 20,
        );
      case Failure(error: final error):
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
    }
  }

  /// プルリフレッシュ
  Future<void> refreshPosts() async {
    if (state.isRefreshing) return;

    state = state.copyWith(
      isRefreshing: true,
      error: null,
    );

    final result = await _postService.getAllPosts(forceRefresh: true);

    switch (result) {
      case Success(data: final posts):
        state = state.copyWith(
          posts: posts,
          isLoading: false,
          lastUpdated: DateTime.now(),
          currentPage: 0,
          hasMorePosts: posts.length >= 20,
        );
      case Failure(error: final error):
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
    }
  }

  /// 次のページ読み込み（無限スクロール）
  Future<void> loadMorePosts() async {
    if (state.isLoadingMore || !state.hasMorePosts) return;

    state = state.copyWith(isLoadingMore: true);

    // 実際の実装ではページネーション対応のAPIを呼び出し
    // ここではダミー処理
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      isLoadingMore: false,
      hasMorePosts: false, // ダミーで終了
    );
  }

  // ===============================
  // 🔍 検索機能
  // ===============================

  /// 検索キーワード更新
  void updateSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);

    // デバウンス処理（実際の実装ではタイマー使用）
    if (keyword.trim().isNotEmpty) {
      _performSearch();
    } else {
      _clearSearch();
    }
  }

  /// 検索実行
  Future<void> _performSearch() async {
    if (state.searchKeyword.trim().isEmpty) return;

    state = state.copyWith(
      isSearching: true,
      showSearchResults: true,
    );

    final result = await _postService.searchPosts(
      keyword: state.searchKeyword,
      userId: state.selectedUserId,
      category: state.selectedCategory,
      sortType: state.sortType,
    );

    switch (result) {
      case Success(data: final posts):
        state = state.copyWith(
          searchResults: posts,
          isSearching: false,
        );
        break;
      case Failure(error: final error):
        state = state.copyWith(
          isSearching: false,
          error: error,
        );
    }
  }

  /// 検索クリア
  void _clearSearch() {
    state = state.copyWith(
      searchKeyword: '',
      searchResults: [],
      showSearchResults: false,
      isSearching: false,
    );
  }

  /// 検索結果表示切り替え
  void toggleSearchResults() {
    state = state.copyWith(
      showSearchResults: !state.showSearchResults,
    );
  }

  // ===============================
  // 🎛️ フィルタリング・ソート
  // ===============================

  /// ユーザーフィルター更新
  void updateUserFilter(int? userId) {
    state = state.copyWith(selectedUserId: userId);
    if (state.showSearchResults) {
      _performSearch();
    }
  }

  /// カテゴリフィルター更新
  void updateCategoryFilter(PostLengthCategory? category) {
    state = state.copyWith(selectedCategory: category);
    if (state.showSearchResults) {
      _performSearch();
    }
  }

  /// ソート種別更新
  void updateSortType(SortType sortType) {
    state = state.copyWith(sortType: sortType);
    if (state.showSearchResults) {
      _performSearch();
    } else {
      // ローカルソート実行
      _sortCurrentPosts();
    }
  }

  /// 現在の投稿リストをソート
  void _sortCurrentPosts() {
    final sortedPosts = _applySorting(state.posts, state.sortType);
    state = state.copyWith(posts: sortedPosts);
  }

  /// フィルター表示切り替え
  void toggleFilters() {
    state = state.copyWith(showFilters: !state.showFilters);
  }

  /// すべてのフィルターをクリア
  void clearAllFilters() {
    state = state.copyWith(
      selectedUserId: null,
      selectedCategory: null,
      sortType: SortType.newest,
      showFilters: false,
    );

    if (state.showSearchResults) {
      _performSearch();
    } else {
      _sortCurrentPosts();
    }
  }

  // ===============================
  // 🎨 表示モード・UI制御
  // ===============================

  /// 表示モード変更
  void changeViewMode(PostsViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  /// 選択モード切り替え
  void toggleSelectionMode() {
    state = state.copyWith(
      isSelectionMode: !state.isSelectionMode,
      selectedPostIds: {},
    );
  }

  /// 投稿選択状態切り替え
  void togglePostSelection(int postId) {
    final selectedIds = Set<int>.from(state.selectedPostIds);

    if (selectedIds.contains(postId)) {
      selectedIds.remove(postId);
    } else {
      selectedIds.add(postId);
    }

    state = state.copyWith(selectedPostIds: selectedIds);
  }

  /// 全選択・全選択解除
  void toggleSelectAll() {
    final currentPosts =
        state.showSearchResults ? state.searchResults : state.posts;

    if (state.selectedPostIds.length == currentPosts.length) {
      // 全選択解除
      state = state.copyWith(selectedPostIds: {});
    } else {
      // 全選択
      final allIds = currentPosts.map((post) => post.id).toSet();
      state = state.copyWith(selectedPostIds: allIds);
    }
  }

  /// 統計表示切り替え
  void toggleAnalytics() {
    state = state.copyWith(showAnalytics: !state.showAnalytics);

    if (state.showAnalytics && state.analytics == null) {
      loadAnalytics();
    }
  }

  /// エラー詳細表示切り替え
  void toggleErrorDetails() {
    state = state.copyWith(showErrorDetails: !state.showErrorDetails);
  }

  // ===============================
  // 📊 統計・分析
  // ===============================

  /// 統計データ読み込み
  Future<void> loadAnalytics() async {
    final result = await _postService.getPostsAnalytics();

    switch (result) {
      case Success(data: final analytics):
        state = state.copyWith(
          analytics: analytics,
        );
      case Failure(error: final error):
        print('Analytics load failed: ${error.message}');
    }
  }

  // ===============================
  // ✏️ 投稿操作
  // ===============================

  /// 投稿削除
  Future<void> deletePost(int postId) async {
    // 楽観的更新：UI から即座に削除
    final updatedPosts =
        state.posts.where((post) => post.id != postId).toList();
    final updatedSearchResults =
        state.searchResults.where((post) => post.id != postId).toList();

    // 削除中状態に設定
    final deletingPosts = Map<int, bool>.from(state.deletingPosts);
    deletingPosts[postId] = true;

    state = state.copyWith(
      posts: updatedPosts,
      searchResults: updatedSearchResults,
      deletingPosts: deletingPosts,
    );

    // 実際の削除処理（現在のユーザーIDは1と仮定）
    final result = await _postService.deletePost(postId, 1);

    switch (result) {
      case Success(data: final _):
        final newDeletingPosts = Map<int, bool>.from(state.deletingPosts);
        newDeletingPosts.remove(postId);

        state = state.copyWith(deletingPosts: newDeletingPosts);
      case Failure(error: final error):
        refreshPosts();
        final newDeletingPosts = Map<int, bool>.from(state.deletingPosts);
        newDeletingPosts.remove(postId);

        state = state.copyWith(
          deletingPosts: newDeletingPosts,
          error: error,
        );
    }
  }

  /// 選択された投稿を一括削除
  Future<void> deleteSelectedPosts() async {
    final selectedIds = List<int>.from(state.selectedPostIds);

    for (final postId in selectedIds) {
      await deletePost(postId);
    }

    // 選択モード終了
    state = state.copyWith(
      isSelectionMode: false,
      selectedPostIds: {},
    );
  }

  /// 投稿編集開始
  void startEditingPost(int postId) {
    state = state.copyWith(editingPostId: postId);
  }

  /// 投稿編集終了
  void stopEditingPost() {
    state = state.copyWith(editingPostId: null);
  }

  // ===============================
  // 🔄 エラーハンドリング
  // ===============================

  /// エラークリア
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// エラーリトライ
  Future<void> retryLastOperation() async {
    if (state.error != null) {
      clearError();

      // 最後の操作に応じてリトライ
      if (state.showSearchResults && state.searchKeyword.isNotEmpty) {
        await _performSearch();
      } else {
        await loadPosts();
      }
    }
  }

  // ===============================
  // 🔧 ヘルパーメソッド
  // ===============================

  /// ソート適用
  List<Post> _applySorting(List<Post> posts, SortType sortType) {
    final sortedPosts = List<Post>.from(posts);

    switch (sortType) {
      case SortType.newest:
        sortedPosts.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortType.oldest:
        sortedPosts.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortType.titleAsc:
        sortedPosts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.titleDesc:
        sortedPosts.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortType.longest:
        sortedPosts.sort((a, b) => b.body.length.compareTo(a.body.length));
        break;
      case SortType.shortest:
        sortedPosts.sort((a, b) => a.body.length.compareTo(b.body.length));
        break;
    }

    return sortedPosts;
  }

  /// 現在表示中の投稿リストを取得
  List<Post> get currentPosts {
    return state.showSearchResults ? state.searchResults : state.posts;
  }

  /// 読み込み中状態判定
  bool get isAnyLoading {
    return state.isLoading ||
        state.isRefreshing ||
        state.isSearching ||
        state.isLoadingMore;
  }

  /// 選択中の投稿数
  int get selectedCount => state.selectedPostIds.length;

  /// 削除中の投稿があるか
  bool get hasAnyDeleting => state.deletingPosts.isNotEmpty;

  /// 特定投稿が削除中か
  bool isPostDeleting(int postId) => state.deletingPosts[postId] ?? false;

  /// フィルターが適用されているか
  bool get hasActiveFilters {
    return state.selectedUserId != null ||
        state.selectedCategory != null ||
        state.sortType != SortType.newest;
  }
}

// ===============================
// 🏭 Provider定義
// ===============================

// Service層のProvider
final postServiceProvider = Provider<PostService>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostService(postRepository: postRepository);
});

// Post画面のStateNotifierProvider
final postPageProvider =
    StateNotifierProvider<PostPageNotifier, PostPageState>((ref) {
  final postService = ref.watch(postServiceProvider);
  return PostPageNotifier(postService);
});

// ===============================
// 🎯 画面状態のセレクター（パフォーマンス最適化）
// ===============================

/// 現在表示中の投稿リストを取得
final currentPostsProvider = Provider<List<Post>>((ref) {
  final state = ref.watch(postPageProvider);
  return state.showSearchResults ? state.searchResults : state.posts;
});

/// エラー状態を取得
final errorStateProvider = Provider<AppException?>((ref) {
  final state = ref.watch(postPageProvider);
  return state.error;
});

/// 読み込み状態を取得
final loadingStateProvider = Provider<bool>((ref) {
  final state = ref.watch(postPageProvider);
  return state.isLoading || state.isRefreshing || state.isSearching;
});

/// 選択モード状態を取得
final selectionModeProvider = Provider<bool>((ref) {
  final state = ref.watch(postPageProvider);
  return state.isSelectionMode;
});

/// フィルター状態を取得
final filterStateProvider =
    Provider<({int? userId, PostLengthCategory? category, SortType sort})>(
        (ref) {
  final state = ref.watch(postPageProvider);
  return (
    userId: state.selectedUserId,
    category: state.selectedCategory,
    sort: state.sortType,
  );
});

// ===============================
// 🧪 テスト用ヘルパー
// ===============================

/// テスト用のモックState作成
PostPageState createMockState({
  List<Post>? posts,
  bool isLoading = false,
  AppException? error,
  String searchKeyword = '',
  bool showSearchResults = false,
}) {
  return PostPageState(
    posts: posts ?? [],
    isLoading: isLoading,
    error: error,
    searchKeyword: searchKeyword,
    showSearchResults: showSearchResults,
  );
}

/// テスト用のモック投稿作成
List<Post> createMockPosts(int count) {
  return List.generate(count, (index) {
    return Post(
      id: index + 1,
      userId: (index % 3) + 1,
      title: 'テスト投稿 ${index + 1}',
      body: 'これはテスト用の投稿内容です。投稿番号: ${index + 1}',
    );
  });
}
