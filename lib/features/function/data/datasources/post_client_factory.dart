// ===============================
// 🏭 PostsApiFactory：API クライアント作成
// ===============================

import 'package:dio/dio.dart';
import 'package:template_app/core/network/dio_client.dart';
import 'package:template_app/features/function/data/datasources/post_client.dart';

/// PostClient のインスタンス作成を管理するファクトリークラス
///
/// 【現場での使用理由】
/// - 依存性注入（DI）の中心点
/// - 設定の一元管理
/// - テスト時のモック差し替えが容易
class PostClientFactory {
  /// 本番用 API クライアント作成
  ///
  /// 【使用例】
  /// ```dart
  /// final postClient = PostsApiFactory.create();
  /// ```
  static PostClient create() {
    // DioClient のシングルトンインスタンスを使用
    // これにより、インターセプター、タイムアウト設定などが適用済み
    return PostClient(DioClient.instance.dio);
  }

  /// カスタム設定での API クライアント作成
  ///
  /// 【使用例】
  /// ```dart
  /// final customDio = Dio(BaseOptions(
  ///   baseUrl: 'https://custom-api.example.com',
  ///   connectTimeout: Duration(seconds: 60),
  /// ));
  /// final postClient = PostsApiFactory.createWithCustomDio(customDio);
  /// ```
  static PostClient createWithCustomDio(Dio dio) {
    return PostClient(dio);
  }

  /// テスト用 API クライアント作成
  ///
  /// 【使用例】
  /// ```dart
  /// final mockDio = MockDio();
  /// final testPostsApi = PostsApiFactory.createForTesting(mockDio);
  /// ```
  static PostClient createForTesting(Dio mockDio) {
    return PostClient(mockDio);
  }

  /// 開発環境用 API クライアント作成
  ///
  /// 【特徴】
  /// - 詳細ログ出力有効
  /// - タイムアウト時間短縮
  /// - デバッグ情報付加
  static PostClient createForDevelopment() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10), // 短縮
      receiveTimeout: const Duration(seconds: 10), // 短縮
    ));

    // 開発用インターセプター追加
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[DEV API] $obj'),
    ));

    return PostClient(dio);
  }
}
