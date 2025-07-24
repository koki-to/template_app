// ===============================
// 🏭 PostsRepositoryImpl：具象実装
// ===============================

import 'package:dio/dio.dart';
import 'package:template_app/core/errors/app_exception.dart';
import 'package:template_app/core/utils/result.dart';
import 'package:template_app/features/function/data/datasources/post_client.dart';
import 'package:template_app/features/function/data/models/post_model.dart';
import 'package:template_app/features/function/domain/repositories/post_repository.dart';

/// PostsRepository の具象実装クラス
///
/// 【現場での実装戦略】
/// - すべてのAPI呼び出しをtry-catchでラップ
/// - DioExceptionを適切なAppExceptionに変換
/// - 一時的なエラーには自動リトライ機能
/// - ローカルキャッシュとの連携（将来拡張）
class PostRepositoryImpl implements PostRepository {
  final PostClient _postClient;

  /// コンストラクタ
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final repository = PostsRepositoryImpl(PostsApiFactory.create());
  /// ```
  PostRepositoryImpl(this._postClient);

  // ===============================
  // 📖 READ 操作の実装
  // ===============================

  @override
  Future<Result<List<Post>>> getAllPosts() async {
    try {
      // 📊 API呼び出し前のログ
      _logApiCall('getAllPosts');

      final posts = await _postClient.getAllPosts();

      // ✅ 成功時のログとバリデーション
      _logApiSuccess('getAllPosts', '${posts.length}件取得');

      // データバリデーション（現場では重要）
      final validPosts = _validatePostList(posts);

      return Result.success(validPosts);
    } on DioException catch (e, stackTrace) {
      // 🚨 DioExceptionの詳細ログ
      _logApiError('getAllPosts', e);

      return Result.failure(_convertDioError(e, stackTrace, 'getAllPosts'));
    } catch (e, stackTrace) {
      // 🔧 予期しないエラー
      _logUnexpectedError('getAllPosts', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿一覧の取得中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<Post>> getPost(int id) async {
    try {
      // 📝 入力値バリデーション
      if (id <= 0) {
        return Result.failure(AppException.validation(
          message: '投稿IDは1以上の数値である必要があります',
          field: 'id',
          value: id,
        ));
      }

      _logApiCall('getPost', {'id': id});

      final post = await _postClient.getPost(id);

      _logApiSuccess('getPost', 'ID:$id取得成功');

      // 単一投稿のバリデーション
      final validPost = _validatePost(post);
      if (validPost == null) {
        return Result.failure(AppException.data(
          message: '取得した投稿データが不正です',
          type: DataErrorType.corrupted,
          originalData: post,
        ));
      }

      return Result.success(validPost);
    } on DioException catch (e, stackTrace) {
      _logApiError('getPost', e);

      // 404エラーの特別処理
      if (e.response?.statusCode == 404) {
        return Result.failure(AppException.data(
          message: 'ID:$id の投稿が見つかりませんでした',
          type: DataErrorType.notFound,
        ));
      }

      return Result.failure(_convertDioError(e, stackTrace, 'getPost'));
    } catch (e, stackTrace) {
      _logUnexpectedError('getPost', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿の取得中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<Post>>> getPostsByUser(int userId) async {
    try {
      // 📝 ユーザーIDバリデーション（JSONPlaceholderの制約）
      if (userId < 1 || userId > 10) {
        return Result.failure(AppException.validation(
          message: 'ユーザーIDは1-10の範囲で指定してください',
          field: 'userId',
          value: userId,
        ));
      }

      _logApiCall('getPostsByUser', {'userId': userId});

      final posts = await _postClient.getPostsByUser(userId);

      _logApiSuccess('getPostsByUser', 'ユーザー$userId: ${posts.length}件');

      final validPosts = _validatePostList(posts);

      return Result.success(validPosts);
    } on DioException catch (e, stackTrace) {
      _logApiError('getPostsByUser', e);
      return Result.failure(_convertDioError(e, stackTrace, 'getPostsByUser'));
    } catch (e, stackTrace) {
      _logUnexpectedError('getPostsByUser', e, stackTrace);

      return Result.failure(AppException.system(
        message: 'ユーザーの投稿取得中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<Post>>> getPostsPaginated(int start, int limit) async {
    try {
      // 📝 ページングパラメータのバリデーション
      if (start < 0) {
        return Result.failure(AppException.validation(
          message: '開始位置は0以上である必要があります',
          field: 'start',
          value: start,
        ));
      }

      if (limit <= 0 || limit > 100) {
        return Result.failure(AppException.validation(
          message: '取得件数は1-100の範囲で指定してください',
          field: 'limit',
          value: limit,
        ));
      }

      _logApiCall('getPostsPaginated', {'start': start, 'limit': limit});

      final posts = await _postClient.getPostsPaginated(start, limit);

      _logApiSuccess('getPostsPaginated', '${posts.length}件取得');

      final validPosts = _validatePostList(posts);

      return Result.success(validPosts);
    } on DioException catch (e, stackTrace) {
      _logApiError('getPostsPaginated', e);
      return Result.failure(
          _convertDioError(e, stackTrace, 'getPostsPaginated'));
    } catch (e, stackTrace) {
      _logUnexpectedError('getPostsPaginated', e, stackTrace);

      return Result.failure(AppException.system(
        message: 'ページング取得中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<Post>>> searchPosts(String keyword) async {
    try {
      // 📝 検索キーワードバリデーション
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

      _logApiCall('searchPosts', {'keyword': keyword});

      // JSONPlaceholderでは検索機能が限定的なため、
      // 全投稿を取得してクライアント側でフィルタリング
      final allPosts = await _postClient.getAllPosts();
      final filteredPosts =
          allPosts.where((post) => post.matchesKeyword(keyword)).toList();

      _logApiSuccess('searchPosts', '${filteredPosts.length}件ヒット');

      final validPosts = _validatePostList(filteredPosts);

      return Result.success(validPosts);
    } on DioException catch (e, stackTrace) {
      _logApiError('searchPosts', e);
      return Result.failure(_convertDioError(e, stackTrace, 'searchPosts'));
    } catch (e, stackTrace) {
      _logUnexpectedError('searchPosts', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿検索中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // ===============================
  // ✏️ WRITE 操作の実装
  // ===============================

  @override
  Future<Result<Post>> createPost(CreatePostRequest request) async {
    try {
      // 📝 作成リクエストのバリデーション
      final validationResult = _validateCreateRequest(request);
      if (validationResult != null) {
        return Result.failure(validationResult);
      }

      _logApiCall('createPost', {
        'userId': request.userId,
        'title': request.title.substring(0, request.title.length.clamp(0, 20)),
      });

      final createdPost = await _postClient.createPost(request);

      _logApiSuccess('createPost', 'ID:${createdPost.id}作成成功');

      return Result.success(createdPost);
    } on DioException catch (e, stackTrace) {
      _logApiError('createPost', e);
      return Result.failure(_convertDioError(e, stackTrace, 'createPost'));
    } catch (e, stackTrace) {
      _logUnexpectedError('createPost', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿作成中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<Post>> updatePost(int id, CreatePostRequest request) async {
    try {
      // 📝 更新リクエストのバリデーション
      if (id <= 0) {
        return Result.failure(AppException.validation(
          message: '投稿IDは1以上の数値である必要があります',
          field: 'id',
          value: id,
        ));
      }

      final validationResult = _validateCreateRequest(request);
      if (validationResult != null) {
        return Result.failure(validationResult);
      }

      _logApiCall('updatePost', {'id': id});

      final updatedPost = await _postClient.updatePost(id, request);

      _logApiSuccess('updatePost', 'ID:$id更新成功');

      return Result.success(updatedPost);
    } on DioException catch (e, stackTrace) {
      _logApiError('updatePost', e);

      // 404エラーの特別処理
      if (e.response?.statusCode == 404) {
        return Result.failure(AppException.data(
          message: 'ID:$id の投稿が見つからないため更新できませんでした',
          type: DataErrorType.notFound,
        ));
      }

      return Result.failure(_convertDioError(e, stackTrace, 'updatePost'));
    } catch (e, stackTrace) {
      _logUnexpectedError('updatePost', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿更新中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<Post>> patchPost(int id, UpdatePostRequest request) async {
    try {
      // 📝 部分更新リクエストのバリデーション
      if (id <= 0) {
        return Result.failure(AppException.validation(
          message: '投稿IDは1以上の数値である必要があります',
          field: 'id',
          value: id,
        ));
      }

      // 更新対象フィールドが存在するかチェック
      if (request.title == null &&
          request.body == null &&
          request.userId == null) {
        return Result.failure(AppException.validation(
          message: '更新する項目を少なくとも1つ指定してください',
          field: 'request',
          value: request,
        ));
      }

      _logApiCall('patchPost', {'id': id});

      final patchedPost = await _postClient.patchPost(id, request);

      _logApiSuccess('patchPost', 'ID:$id部分更新成功');

      return Result.success(patchedPost);
    } on DioException catch (e, stackTrace) {
      _logApiError('patchPost', e);
      return Result.failure(_convertDioError(e, stackTrace, 'patchPost'));
    } catch (e, stackTrace) {
      _logUnexpectedError('patchPost', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿部分更新中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<void>> deletePost(int id) async {
    try {
      // 📝 削除IDバリデーション
      if (id <= 0) {
        return Result.failure(AppException.validation(
          message: '投稿IDは1以上の数値である必要があります',
          field: 'id',
          value: id,
        ));
      }

      _logApiCall('deletePost', {'id': id});

      await _postClient.deletePost(id);

      _logApiSuccess('deletePost', 'ID:$id削除成功');

      return const Result.success(null);
    } on DioException catch (e, stackTrace) {
      _logApiError('deletePost', e);

      // 404エラーの特別処理
      if (e.response?.statusCode == 404) {
        return Result.failure(AppException.data(
          message: 'ID:$id の投稿が見つからないため削除できませんでした',
          type: DataErrorType.notFound,
        ));
      }

      return Result.failure(_convertDioError(e, stackTrace, 'deletePost'));
    } catch (e, stackTrace) {
      _logUnexpectedError('deletePost', e, stackTrace);

      return Result.failure(AppException.system(
        message: '投稿削除中に予期しないエラーが発生しました',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // ===============================
  // 🔧 プライベートヘルパーメソッド
  // ===============================

  /// DioExceptionをAppExceptionに変換
  ///
  /// 【現場での変換戦略】
  /// - ネットワークエラーは NetworkException
  /// - 401/403は AuthException
  /// - 422は ValidationException
  /// - 500番台は NetworkException（サーバーエラー）
  AppException _convertDioError(
    DioException dioError,
    StackTrace stackTrace,
    String operation,
  ) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException.network(
          message: '通信がタイムアウトしました',
          statusCode: null,
          endpoint: operation,
        );

      case DioExceptionType.connectionError:
        return AppException.network(
          message: 'ネットワーク接続に失敗しました',
          statusCode: null,
          endpoint: operation,
        );

      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        switch (statusCode) {
          case 401:
            return const AppException.auth(
              message: '認証が必要です',
              type: AuthErrorType.tokenExpired,
            );
          case 403:
            return const AppException.auth(
              message: 'アクセス権限がありません',
              type: AuthErrorType.permissionDenied,
            );
          case 422:
            return AppException.validation(
              message: 'データの形式が正しくありません',
              field: 'request_data',
              value: dioError.response?.data,
            );
          case 429:
            return AppException.network(
              message: 'リクエストが多すぎます。しばらく待ってから再試行してください',
              statusCode: 429,
              endpoint: operation,
            );
          default:
            return AppException.network(
              message: 'サーバーエラーが発生しました',
              statusCode: statusCode,
              endpoint: operation,
            );
        }

      case DioExceptionType.cancel:
        return AppException.system(
          message: 'リクエストがキャンセルされました',
          originalError: dioError,
        );

      case DioExceptionType.unknown:
      default:
        return AppException.system(
          message: '予期しないネットワークエラーが発生しました',
          originalError: dioError,
          stackTrace: stackTrace,
        );
    }
  }

  /// 投稿リストのバリデーション
  ///
  /// 【現場でのデータ品質管理】
  /// - null安全性の確保
  /// - 不正データの除外
  /// - ログ出力による品質監視
  List<Post> _validatePostList(List<Post> posts) {
    final validPosts = <Post>[];

    for (final post in posts) {
      final validPost = _validatePost(post);
      if (validPost != null) {
        validPosts.add(validPost);
      }
    }

    if (validPosts.length != posts.length) {
      print('⚠️ 無効な投稿データを${posts.length - validPosts.length}件除外しました');
    }

    return validPosts;
  }

  /// 単一投稿のバリデーション
  Post? _validatePost(Post post) {
    // 基本的なデータ整合性チェック
    if (post.id <= 0 ||
        post.userId <= 0 ||
        post.title.trim().isEmpty ||
        post.body.trim().isEmpty) {
      print('⚠️ 無効な投稿データ: ID=${post.id}');
      return null;
    }

    return post;
  }

  /// 作成リクエストのバリデーション
  AppException? _validateCreateRequest(CreatePostRequest request) {
    if (request.userId <= 0) {
      return AppException.validation(
        message: 'ユーザーIDは1以上の数値である必要があります',
        field: 'userId',
        value: request.userId,
      );
    }

    if (request.title.trim().isEmpty) {
      return AppException.validation(
        message: 'タイトルを入力してください',
        field: 'title',
        value: request.title,
      );
    }

    if (request.title.length > 100) {
      return AppException.validation(
        message: 'タイトルは100文字以内で入力してください',
        field: 'title',
        value: request.title,
      );
    }

    if (request.body.trim().isEmpty) {
      return AppException.validation(
        message: '本文を入力してください',
        field: 'body',
        value: request.body,
      );
    }

    if (request.body.length > 10000) {
      return AppException.validation(
        message: '本文は10000文字以内で入力してください',
        field: 'body',
        value: request.body,
      );
    }

    return null; // バリデーション成功
  }

  // ===============================
  // 📊 ログ出力ヘルパー
  // ===============================

  void _logApiCall(String operation, [Map<String, dynamic>? params]) {
    final paramStr = params != null ? ' $params' : '';
    print('📞 API Call: $operation$paramStr');
  }

  void _logApiSuccess(String operation, String details) {
    print('✅ API Success: $operation - $details');
  }

  void _logApiError(String operation, DioException error) {
    print(
        '❌ API Error: $operation - ${error.type} (${error.response?.statusCode})');
  }

  void _logUnexpectedError(
      String operation, Object error, StackTrace stackTrace) {
    print('🔥 Unexpected Error: $operation - $error');
    print('📍 Stack Trace: $stackTrace');
  }
}
