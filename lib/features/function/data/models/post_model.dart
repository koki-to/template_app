// lib/data/models/post_model.dart
// JSONPlaceholder API対応のPostモデル（Freezed 3.0対応）

import 'package:freezed_annotation/freezed_annotation.dart';

// 🔧 コード生成用ファイル指定
// Freezed 3.0では sealed class 必須
part 'post_model.freezed.dart';
part 'post_model.g.dart';

// ===============================
// 📝 Post：ブログ投稿データモデル
// ===============================

/// JSONPlaceholder APIのPostデータを表現するモデルクラス
///
/// 【JSONPlaceholder APIレスポンス例】
/// ```json
/// {
///   "userId": 1,
///   "id": 1,
///   "title": "sunt aut facere repellat provident",
///   "body": "quia et suscipit\nsuscipit recusandae..."
/// }
/// ```
///
/// 【現場での使い方】
/// - APIレスポンスの自動パース
/// - UI表示用データの型安全な管理
/// - テストデータの簡単作成
@freezed
sealed class Post with _$Post {
  /// 標準的なPost作成
  ///
  /// 【パラメータ説明】
  /// - [userId]: 投稿者ID（1-10の範囲、JSONPlaceholderの制約）
  /// - [id]: 投稿ID（一意識別子）
  /// - [title]: 投稿タイトル（必須）
  /// - [body]: 投稿本文（必須）
  const factory Post({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) = _Post;

  /// JSONからPostオブジェクトを作成
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final post = Post.fromJson(apiResponse);
  /// ```
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

// ===============================
// 📊 PostList：投稿リスト管理
// ===============================

/// 複数の投稿を管理するためのコンテナクラス
///
/// 【現場での使用例】
/// - API から取得した投稿リストの管理
/// - ページネーション情報の保持
/// - 検索・フィルタリング結果の保持
@freezed
sealed class PostList with _$PostList {
  const factory PostList({
    @Default([]) List<Post> posts, // 投稿リスト
    @Default(0) int totalCount, // 総投稿数
    @Default(false) bool hasMore, // 追加データの有無
    @Default(1) int currentPage, // 現在のページ番号
  }) = _PostList;

  factory PostList.fromJson(Map<String, dynamic> json) =>
      _$PostListFromJson(json);
}

// ===============================
// 🔧 Post作成・更新用DTO
// ===============================

/// 新規投稿作成時のデータ転送オブジェクト
///
/// 【現場での使い方】
/// - フォーム入力値の管理
/// - バリデーション前のデータ保持
/// - API送信用データの構築
@freezed
sealed class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required int userId,
    required String title,
    required String body,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}

/// 投稿更新時のデータ転送オブジェクト
///
/// 【現場での使い方】
/// - 部分更新（PATCH）リクエスト
/// - 編集フォームのデータ管理
@freezed
sealed class UpdatePostRequest with _$UpdatePostRequest {
  const factory UpdatePostRequest({
    int? userId, // null の場合は更新しない
    String? title, // null の場合は更新しない
    String? body, // null の場合は更新しない
  }) = _UpdatePostRequest;

  factory UpdatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostRequestFromJson(json);
}

// ===============================
// 🎨 Post拡張メソッド
// ===============================

/// Postクラスに便利なメソッドを追加
///
/// 【現場での使用例】
/// - UI表示用の加工データ生成
/// - ビジネスロジック用の判定メソッド
/// - 検索・フィルタリング用メソッド
extension PostExtension on Post {
  /// 投稿の要約テキスト（UI表示用）
  ///
  /// 【使用例】
  /// ```dart
  /// Text(post.summary), // 最初の100文字 + "..."
  /// ```
  String get summary {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }

  /// タイトルが長すぎるかの判定
  ///
  /// 【現場でのUI制御例】
  /// ```dart
  /// if (post.isLongTitle) {
  ///   // 2行表示に切り替え
  /// }
  /// ```
  bool get isLongTitle => title.length > 50;

  /// 投稿本文の推定読了時間（分）
  ///
  /// 【計算根拠】
  /// - 一般的な読書速度：200文字/分
  /// - 最低1分として設定
  int get estimatedReadingTime {
    final wordsCount = body.length;
    final minutes = (wordsCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  /// 投稿の文字数カテゴリ
  ///
  /// 【現場での使用例】
  /// - UI での表示スタイル切り替え
  /// - 分析・統計処理
  PostLengthCategory get lengthCategory {
    if (body.length < 100) return PostLengthCategory.short;
    if (body.length < 500) return PostLengthCategory.medium;
    return PostLengthCategory.long;
  }

  /// 検索キーワードにマッチするかの判定
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final filteredPosts = posts.where((post) =>
  ///   post.matchesKeyword(searchQuery)
  /// ).toList();
  /// ```
  bool matchesKeyword(String keyword) {
    if (keyword.isEmpty) return true;

    final lowerKeyword = keyword.toLowerCase();
    return title.toLowerCase().contains(lowerKeyword) ||
        body.toLowerCase().contains(lowerKeyword);
  }

  /// 特定ユーザーの投稿かの判定
  bool isAuthoredBy(int targetUserId) => userId == targetUserId;

  /// デバッグ用の詳細情報
  ///
  /// 【開発時の使用例】
  /// ```dart
  /// print(post.debugInfo); // 開発時のデータ確認
  /// ```
  String get debugInfo {
    return '''
Post Debug Info:
  ID: $id
  User ID: $userId
  Title: $title
  Body Length: ${body.length} chars
  Reading Time: ${estimatedReadingTime}min
  Category: ${lengthCategory.name}
''';
  }
}

// ===============================
// 📏 投稿の文字数カテゴリ
// ===============================

/// 投稿の文字数による分類
///
/// 【現場での使用例】
/// - UI レイアウトの動的変更
/// - パフォーマンス最適化
/// - ユーザー体験の個人化
enum PostLengthCategory {
  short, // 短文（100文字未満）
  medium, // 中文（100-500文字）
  long, // 長文（500文字以上）
}
