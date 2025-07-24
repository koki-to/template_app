import 'package:template_app/core/utils/result.dart';
import 'package:template_app/features/function/data/models/post_model.dart';

// ===============================
// 📚 PostsRepository：投稿データアクセス層
// ===============================

/// 投稿データの取得・操作を管理するリポジトリクラス
///
/// 【現場での Repository パターンの価値】
/// 1. データソースの抽象化（API、ローカルDB、キャッシュの統一インターフェース）
/// 2. エラーハンドリングの一元化（DioException → AppException変換）
/// 3. ビジネスロジックとデータアクセスの分離
/// 4. テスト容易性（モック・スタブでのテスト）
/// 5. キャッシュ戦略の透明な実装
///
/// 【Result型使用の利点】
/// - 例外を使わない安全なエラーハンドリング
/// - コンパイル時のエラー処理漏れチェック
/// - 関数型プログラミングのベストプラクティス適用
abstract class PostRepository {
  // ===============================
  // 📖 READ 操作
  // ===============================

  /// すべての投稿を取得
  Future<Result<List<Post>>> getAllPosts();

  /// 特定の投稿を取得
  Future<Result<Post>> getPost(int id);

  /// 特定ユーザーの投稿を取得
  Future<Result<List<Post>>> getPostsByUser(int userId);

  /// ページング付き投稿取得
  Future<Result<List<Post>>> getPostsPaginated(int start, int limit);

  /// 投稿検索
  Future<Result<List<Post>>> searchPosts(String keyword);

  // ===============================
  // ✏️ WRITE 操作
  // ===============================

  /// 新規投稿作成
  Future<Result<Post>> createPost(CreatePostRequest request);

  /// 投稿更新
  Future<Result<Post>> updatePost(int id, CreatePostRequest request);

  /// 投稿部分更新
  Future<Result<Post>> patchPost(int id, UpdatePostRequest request);

  /// 投稿削除
  Future<Result<void>> deletePost(int id);
}
