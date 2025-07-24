// ===============================
// 🏭 PostFactory：テスト用ファクトリー
// ===============================

import 'package:template_app/features/function/data/models/post_model.dart';

/// テスト用のPostデータを簡単に作成するファクトリークラス
///
/// 【現場での使用例】
/// - ユニットテストのテストデータ作成
/// - ウィジェットテストのモックデータ
/// - デモ・プロトタイプ用のサンプルデータ
class PostFactory {
  /// デフォルトの投稿作成
  ///
  /// 【使用例】
  /// ```dart
  /// final post = PostFactory.createDefault();
  /// ```
  static Post createDefault() {
    return const Post(
      userId: 1,
      id: 1,
      title: 'サンプル投稿タイトル',
      body: 'これはサンプルの投稿本文です。テスト用のデータとして使用されます。',
    );
  }

  /// 指定された数のサンプル投稿リスト作成
  ///
  /// 【使用例】
  /// ```dart
  /// final posts = PostFactory.createSampleList(5);
  /// ```
  static List<Post> createSampleList(int count) {
    return List.generate(count, (index) {
      return Post(
        userId: (index % 3) + 1, // 1-3のユーザーIDでローテーション
        id: index + 1,
        title: 'サンプル投稿 ${index + 1}',
        body: 'これは${index + 1}番目のサンプル投稿です。'
            'テスト用のデータとして作成されました。'
            '内容は${index.isEven ? '短め' : '長めの文章になっています。'}',
      );
    });
  }

  /// 長い本文を持つ投稿作成（UI テスト用）
  ///
  /// 【使用例】
  /// ```dart
  /// final longPost = PostFactory.createLongPost();
  /// ```
  static Post createLongPost() {
    return const Post(
      userId: 1,
      id: 999,
      title: '非常に長いタイトルを持つ投稿のサンプルです。UI の表示テスト用に作成されました。',
      body: '''
これは非常に長い本文を持つ投稿のサンプルです。

UI コンポーネントのテストや、文字数制限の動作確認、
レイアウトの崩れチェックなどに使用されます。

実際のアプリケーションでは、ユーザーが長文を投稿する可能性があるため、
このようなテストデータで事前に問題を発見することが重要です。

Flutter の Text ウィジェットの overflow 処理、
スクロール可能な領域での表示、
そしてパフォーマンスへの影響なども
このようなデータで確認できます。

現場開発では、極端なケースのテストデータを用意することで、
より堅牢なアプリケーションを構築できます。
''',
    );
  }

  /// エラー状態のテスト用投稿
  ///
  /// 【使用例】
  /// ```dart
  /// final errorPost = PostFactory.createErrorState();
  /// ```
  static Post createErrorState() {
    return const Post(
      userId: -1,
      id: -1,
      title: 'ERROR_TITLE',
      body: 'ERROR_BODY',
    );
  }
}
