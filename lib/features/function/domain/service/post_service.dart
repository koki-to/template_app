import 'package:template_app/core/errors/app_exception.dart';
import 'package:template_app/core/utils/result.dart';
import 'package:template_app/features/function/data/models/post_model.dart';
import 'package:template_app/features/function/domain/repositories/post_repository.dart';

class PostService {
  PostService({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  final PostRepository _postRepository;

  // 簡易インメモリキャッシュ（実際はHive/Sqfliteを使用）
  List<Post>? _cachedPosts;
  DateTime? _cacheTime;
  static const _cacheMaxAge = Duration(minutes: 5);

  Future<Result<List<Post>>> getAllPosts({bool forceRefresh = false}) async {
    try {
      // キャッシュチェック
      if (!forceRefresh && _isCacheValid()) {
        _logBusinessEvent(
            'posts_loaded_from_cache', {'count': _cachedPosts!.length});
        return Result.success(_cachedPosts!);
      }

      final result = await _postRepository.getAllPosts();

      return result.map((posts) {
        // ビジネスロジック：データの前処理
        final processedPosts = _processPostsData(posts);

        // キャッシュ更新
        _updateCache(processedPosts);

        // 分析イベント送信
        _logBusinessEvent('posts_loaded_from_api', {
          'count': processedPosts.length,
          'cache_refresh': forceRefresh,
        });

        return processedPosts;
      });
    } catch (e) {
      _logBusinessEvent('posts_load_failed', {'error': e.toString()});
      return Result.failure(AppException.system(
        message: '投稿一覧の取得処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<Post>> getPost(int id) async {
    try {
      // ビジネスルール：IDの妥当性チェック
      if (id <= 0) {
        return Result.failure(AppException.validation(
          message: '投稿IDは正の数値である必要があります',
          field: 'id',
          value: id,
        ));
      }

      // キャッシュから検索を試行
      if (_cachedPosts != null) {
        final cachedPost = _cachedPosts!.where((p) => p.id == id).firstOrNull;
        if (cachedPost != null) {
          _logBusinessEvent('post_loaded_from_cache', {'id': id});
          return Result.success(cachedPost);
        }
      }

      final result = await _postRepository.getPost(id);

      return result.map((post) {
        // 分析イベント送信
        _logBusinessEvent('post_viewed', {
          'id': post.id,
          'userId': post.userId,
          'length_category': post.lengthCategory.name,
        });

        return post;
      });
    } catch (e) {
      _logBusinessEvent('post_load_failed', {'id': id, 'error': e.toString()});
      return Result.failure(AppException.system(
        message: '投稿取得処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<List<Post>>> getUserPosts(int userId) async {
    try {
      // ビジネスルール：ユーザーIDの妥当性チェック
      if (userId <= 0 || userId > 10) {
        return Result.failure(AppException.validation(
          message: 'ユーザーIDは1-10の範囲で指定してください',
          field: 'userId',
          value: userId,
        ));
      }

      final result = await _postRepository.getPostsByUser(userId);

      return result.map((posts) {
        // ビジネスロジック：ユーザー投稿の統計計算
        final sortedPosts = _sortPostsByNewest(posts);

        _logBusinessEvent('user_posts_loaded', {
          'userId': userId,
          'count': posts.length,
        });

        return sortedPosts;
      });
    } catch (e) {
      return Result.failure(AppException.system(
        message: 'ユーザー投稿取得処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<List<Post>>> searchPosts({
    required String keyword,
    int? userId,
    PostLengthCategory? category,
    SortType sortType = SortType.newest,
  }) async {
    try {
      // ビジネスルール：検索条件の妥当性チェック
      if (keyword.trim().isEmpty) {
        return Result.failure(AppException.validation(
          message: '検索キーワードを入力してください',
          field: 'keyword',
          value: keyword,
        ));
      }

      if (keyword.length < 2) {
        return Result.failure(AppException.validation(
          message: '検索キーワードは2文字以上で入力してください',
          field: 'keyword',
          value: keyword,
        ));
      }

      // 基本検索実行
      final result = await _postRepository.searchPosts(keyword);

      return result.map((posts) {
        var filteredPosts = posts;

        // ビジネスロジック：追加フィルタリング
        if (userId != null) {
          filteredPosts =
              filteredPosts.where((p) => p.userId == userId).toList();
        }

        if (category != null) {
          filteredPosts =
              filteredPosts.where((p) => p.lengthCategory == category).toList();
        }

        // ソート処理
        final sortedPosts = _sortPosts(filteredPosts, sortType);

        // 検索分析イベント
        _logBusinessEvent('search_executed', {
          'keyword': keyword,
          'userId': userId,
          'category': category?.name,
          'sortType': sortType.name,
          'results': sortedPosts.length,
        });

        return sortedPosts;
      });
    } catch (e) {
      return Result.failure(AppException.system(
        message: '検索処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<Post>> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      // ビジネスルール：作成可能性チェック
      final validationResult = _validatePostCreation(userId, title, body);
      if (validationResult != null) {
        return Result.failure(validationResult);
      }

      // 重複チェック（同一ユーザーの同一タイトル）
      final duplicateCheckResult = await _checkDuplicateTitle(userId, title);
      if (duplicateCheckResult != null) {
        return Result.failure(duplicateCheckResult);
      }

      final request = CreatePostRequest(
        userId: userId,
        title: title.trim(),
        body: body.trim(),
      );

      final result = await _postRepository.createPost(request);

      return result.map((post) {
        // キャッシュ無効化
        _invalidateCache();

        // 分析イベント送信
        _logBusinessEvent('post_created', {
          'userId': userId,
          'length_category': post.lengthCategory.name,
          'title_length': title.length,
          'body_length': body.length,
        });

        return post;
      });
    } catch (e) {
      return Result.failure(AppException.system(
        message: '投稿作成処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<Post>> updatePost({
    required int postId,
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      // ビジネスルール：更新権限チェック
      final permissionResult = await _checkUpdatePermission(postId, userId);
      if (permissionResult != null) {
        return Result.failure(permissionResult);
      }

      // バリデーション
      final validationResult = _validatePostCreation(userId, title, body);
      if (validationResult != null) {
        return Result.failure(validationResult);
      }

      final request = CreatePostRequest(
        userId: userId,
        title: title.trim(),
        body: body.trim(),
      );

      final result = await _postRepository.updatePost(postId, request);

      return result.map((post) {
        // キャッシュ無効化
        _invalidateCache();

        _logBusinessEvent('post_updated', {
          'postId': postId,
          'userId': userId,
        });

        return post;
      });
    } catch (e) {
      return Result.failure(AppException.system(
        message: '投稿更新処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<void>> deletePost(int postId, int userId) async {
    try {
      // ビジネスルール：削除権限チェック
      final permissionResult = await _checkDeletePermission(postId, userId);
      if (permissionResult != null) {
        return Result.failure(permissionResult);
      }

      final result = await _postRepository.deletePost(postId);

      return result.map((_) {
        // キャッシュ無効化
        _invalidateCache();

        _logBusinessEvent('post_deleted', {
          'postId': postId,
          'userId': userId,
        });

        return;
      });
    } catch (e) {
      return Result.failure(AppException.system(
        message: '投稿削除処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  Future<Result<PostsAnalytics>> getPostsAnalytics() async {
    try {
      final result = await getAllPosts();

      return result.map((posts) {
        final analytics = _calculateAnalytics(posts);

        _logBusinessEvent('analytics_calculated', {
          'total_posts': analytics.totalPosts,
          'total_users': analytics.totalUsers,
        });

        return analytics;
      });
    } catch (e) {
      return Result.failure(AppException.system(
        message: '統計計算処理でエラーが発生しました',
        originalError: e,
      ));
    }
  }

  // ===============================
  // 🔧 プライベートヘルパーメソッド
  // ===============================

  /// キャッシュの有効性チェック
  bool _isCacheValid() {
    return _cachedPosts != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheMaxAge;
  }

  /// キャッシュ更新
  void _updateCache(List<Post> posts) {
    _cachedPosts = posts;
    _cacheTime = DateTime.now();
  }

  /// キャッシュ無効化
  void _invalidateCache() {
    _cachedPosts = null;
    _cacheTime = null;
  }

  /// 投稿データの前処理
  List<Post> _processPostsData(List<Post> posts) {
    // ビジネスロジック：不正データの除外、正規化など
    return posts
        .where((post) => post.title.isNotEmpty && post.body.isNotEmpty)
        .toList();
  }

  /// 投稿作成バリデーション
  AppException? _validatePostCreation(int userId, String title, String body) {
    if (userId <= 0 || userId > 10) {
      return AppException.validation(
        message: 'ユーザーIDは1-10の範囲で指定してください',
        field: 'userId',
        value: userId,
      );
    }

    if (title.trim().isEmpty) {
      return AppException.validation(
        message: 'タイトルを入力してください',
        field: 'title',
        value: title,
      );
    }

    if (title.length > 100) {
      return AppException.validation(
        message: 'タイトルは100文字以内で入力してください',
        field: 'title',
        value: title,
      );
    }

    if (body.trim().isEmpty) {
      return AppException.validation(
        message: '本文を入力してください',
        field: 'body',
        value: body,
      );
    }

    if (body.length > 10000) {
      return AppException.validation(
        message: '本文は10000文字以内で入力してください',
        field: 'body',
        value: body,
      );
    }

    return null;
  }

  /// 重複タイトルチェック
  Future<AppException?> _checkDuplicateTitle(int userId, String title) async {
    // JSONPlaceholderでは実装できないため、モック処理
    // 実際のプロジェクトでは、DBでの重複チェック処理
    return null;
  }

  /// 更新権限チェック
  Future<AppException?> _checkUpdatePermission(int postId, int userId) async {
    try {
      final result = await _postRepository.getPost(postId);
      switch (result) {
        case Success(data: final post):
          if (post.userId != userId) {
            return const AppException.auth(
              message: '他のユーザーの投稿は編集できません',
              type: AuthErrorType.permissionDenied,
            );
          }
          return null;
        case Failure(error: final error):
          return error;
      }
    } catch (e) {
      return AppException.system(
        message: '権限チェック処理でエラーが発生しました',
        originalError: e,
      );
    }
  }

  /// 削除権限チェック
  Future<AppException?> _checkDeletePermission(int postId, int userId) async {
    return _checkUpdatePermission(postId, userId);
  }

  /// 投稿ソート処理
  List<Post> _sortPosts(List<Post> posts, SortType sortType) {
    switch (sortType) {
      case SortType.newest:
        return posts..sort((a, b) => b.id.compareTo(a.id));
      case SortType.oldest:
        return posts..sort((a, b) => a.id.compareTo(b.id));
      case SortType.titleAsc:
        return posts..sort((a, b) => a.title.compareTo(b.title));
      case SortType.titleDesc:
        return posts..sort((a, b) => b.title.compareTo(a.title));
      case SortType.longest:
        return posts..sort((a, b) => b.body.length.compareTo(a.body.length));
      case SortType.shortest:
        return posts..sort((a, b) => a.body.length.compareTo(b.body.length));
    }
  }

  /// 最新順ソート
  List<Post> _sortPostsByNewest(List<Post> posts) {
    return _sortPosts(posts, SortType.newest);
  }

  /// 統計計算
  PostsAnalytics _calculateAnalytics(List<Post> posts) {
    final userPosts = <int, int>{};
    final categoryPosts = <PostLengthCategory, int>{
      PostLengthCategory.short: 0,
      PostLengthCategory.medium: 0,
      PostLengthCategory.long: 0,
    };

    double totalLength = 0;

    for (final post in posts) {
      userPosts[post.userId] = (userPosts[post.userId] ?? 0) + 1;
      categoryPosts[post.lengthCategory] =
          categoryPosts[post.lengthCategory]! + 1;
      totalLength += post.body.length;
    }

    return PostsAnalytics(
      totalPosts: posts.length,
      totalUsers: userPosts.keys.length,
      averageLength: posts.isNotEmpty ? totalLength / posts.length : 0,
      postsByUser: userPosts,
      postsByCategory: categoryPosts,
    );
  }

  /// ビジネスイベントログ
  void _logBusinessEvent(String event, Map<String, dynamic> properties) {
    // 実際の実装では分析サービス（Firebase Analytics等）に送信
    print('📊 Business Event: $event - $properties');
  }
}

enum SortType {
  newest, // 新しい順（ID降順）
  oldest, // 古い順（ID昇順）
  titleAsc, // タイトル昇順
  titleDesc, // タイトル降順
  longest, // 長い順
  shortest, // 短い順
}

/// 投稿分析データ
class PostsAnalytics {
  final int totalPosts;
  final int totalUsers;
  final double averageLength;
  final Map<int, int> postsByUser;
  final Map<PostLengthCategory, int> postsByCategory;

  const PostsAnalytics({
    required this.totalPosts,
    required this.totalUsers,
    required this.averageLength,
    required this.postsByUser,
    required this.postsByCategory,
  });
}
