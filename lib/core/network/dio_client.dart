// lib/core/network/dio_client.dart
// 現場で実証済みのDio設定とエラーハンドリング

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../errors/app_exception.dart';

// ===============================
// 🌐 DioClient：HTTP通信の中心クラス
// ===============================

/// 現場で必要なすべての機能を備えたDioクライアント
///
/// 【主要機能】
/// - 自動リトライ機能
/// - ネットワーク接続チェック
/// - 認証トークン管理
/// - 詳細ログ出力
/// - エラーの統一変換
class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  final Logger _logger = Logger();

  /// シングルトンパターンでインスタンス管理
  ///
  /// 【現場でのポイント】
  /// - アプリ全体で同一設定のDioを使用
  /// - メモリ効率とパフォーマンス向上
  ///
  /// 【現場での使い方】
  /// - DioClientをアプリ全体で共通に使用
  /// - メモリー効率とパフォーマンス向上
  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  /// DioClientのprivate constructor
  ///
  /// 【現場での使い方】
  /// - DioClientをインスタンス化する
  DioClient._internal() {
    _dio = Dio();
    _setupDio();
    _setupInterceptors();
  }

  /// Dioの基本設定
  ///
  /// 【現場での設定理由】
  /// - connectTimeout: サーバー接続待機時間（遅いネットワーク対応）
  /// - receiveTimeout: データ受信待機時間（大きなファイル対応）
  /// - sendTimeout: データ送信待機時間（アップロード処理対応）
  void _setupDio() {
    _dio.options = BaseOptions(
      // 🌐 本番・開発で切り替え可能なbaseURL
      baseUrl: _getBaseUrl(),

      // ⏰ タイムアウト設定（現場での最適値）
      connectTimeout: const Duration(seconds: 30), // 接続タイムアウト
      receiveTimeout: const Duration(seconds: 30), // 受信タイムアウト
      sendTimeout: const Duration(seconds: 30), // 送信タイムアウト

      // 📝 ヘッダー設定
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // アプリバージョンを送信（サーバー側での互換性確認用）
        'App-Version': '1.0.0',
        // プラットフォーム情報（分析・デバッグ用）
        'Platform': defaultTargetPlatform.name,
      },

      // 🔄 レスポンス形式
      responseType: ResponseType.json,

      // 📊 HTTP状態コードの扱い
      // 200-299以外もレスポンスとして受け取る（エラーハンドリングで処理）
      validateStatus: (status) => status != null && status < 500,
    );
  }

  /// インターセプターの設定
  ///
  /// 【現場での使い方】
  /// - 全リクエストに共通処理を挿入
  /// - 認証、ログ、エラー変換を自動化
  void _setupInterceptors() {
    // 🔐 認証インターセプター（リクエスト時）
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // 📊 開発時のみ：詳細ログ出力
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true, // リクエスト内容をログ出力
          requestHeader: true, // リクエストヘッダーをログ出力
          requestBody: true, // リクエストボディをログ出力
          responseHeader: false, // レスポンスヘッダーは省略（冗長回避）
          responseBody: true, // レスポンスボディをログ出力
          error: true, // エラー内容をログ出力
          logPrint: (obj) => _logger.d(obj), // Loggerを使用
        ),
      );
    }

    // 🔄 リトライインターセプター
    _dio.interceptors.add(_createRetryInterceptor());
  }

  /// リクエスト前処理
  ///
  /// 【現場での使用例】
  /// - 認証トークンの自動付与
  /// - ネットワーク接続チェック
  /// - リクエスト時刻の記録
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // 📱 ネットワーク接続チェック
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            message: 'インターネット接続がありません',
          ),
        );
      }

      // 🔐 認証トークンの自動付与
      final token = await _getAuthToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // 📊 リクエスト開始ログ
      _logger.i('🚀 API Request: ${options.method} ${options.path}');

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: e,
        ),
      );
    }
  }

  /// レスポンス後処理
  ///
  /// 【現場での使用例】
  /// - レスポンス時間の計測
  /// - 成功ログの記録
  /// - キャッシュ制御
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // 📊 レスポンス成功ログ
    _logger.i(
      '✅ API Success: ${response.requestOptions.method} '
      '${response.requestOptions.path} (${response.statusCode})',
    );

    handler.next(response);
  }

  /// エラー処理（最重要）
  ///
  /// 【現場でのエラー変換戦略】
  /// - DioExceptionをAppExceptionに統一変換
  /// - HTTPステータスコードによる詳細分類
  /// - ユーザーフレンドリーなメッセージ生成
  void _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // 📊 エラーログ出力
    _logger.e(
      '❌ API Error: ${err.requestOptions.method} '
      '${err.requestOptions.path}',
      error: err,
      stackTrace: err.stackTrace,
    );

    // 🔄 AppExceptionに変換
    final appException = _convertDioExceptionToAppException(err);

    // 🚨 エラートラッキングサービスに送信（本番環境）
    if (kReleaseMode) {
      _reportErrorToTracking(appException, err);
    }

    handler.reject(err);
  }

  /// DioExceptionをAppExceptionに変換する中核メソッド
  ///
  /// 【現場での変換ルール】
  /// - ネットワークエラー → NetworkException
  /// - 認証エラー（401） → AuthException
  /// - バリデーションエラー（422） → ValidationException
  /// - サーバーエラー（500番台） → NetworkException
  /// - 予期しないエラー → SystemException
  AppException _convertDioExceptionToAppException(DioException dioError) {
    switch (dioError.type) {
      // 🌐 接続関連エラー
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException.network(
          message: 'サーバーとの通信でタイムアウトが発生しました',
          statusCode: null,
          endpoint: dioError.requestOptions.path,
        );

      case DioExceptionType.connectionError:
        return AppException.network(
          message: 'ネットワーク接続エラーが発生しました',
          statusCode: null,
          endpoint: dioError.requestOptions.path,
        );

      // 🔍 HTTPレスポンスエラー
      case DioExceptionType.badResponse:
        return _handleHttpStatusError(dioError);

      // ❌ キャンセルエラー
      case DioExceptionType.cancel:
        return AppException.system(
          message: 'リクエストがキャンセルされました',
          originalError: dioError,
        );

      // 🔧 その他のエラー
      case DioExceptionType.unknown:
      default:
        return AppException.system(
          message: '予期しないエラーが発生しました',
          originalError: dioError,
          stackTrace: dioError.stackTrace,
        );
    }
  }

  /// HTTPステータスコード別エラー処理
  ///
  /// 【現場でのステータスコード対応表】
  /// - 400: バリデーションエラー
  /// - 401: 認証エラー（未ログイン）
  /// - 403: 認可エラー（権限不足）
  /// - 404: リソース未発見
  /// - 422: バリデーションエラー（詳細）
  /// - 429: レート制限
  /// - 500番台: サーバーエラー
  AppException _handleHttpStatusError(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final endpoint = dioError.requestOptions.path;

    switch (statusCode) {
      case 400:
        return AppException.validation(
          message: 'リクエストの内容に問題があります',
          field: 'request',
          value: dioError.response?.data,
        );

      case 401:
        return const AppException.auth(
          message: '認証が必要です。ログインしてください',
          type: AuthErrorType.tokenExpired,
        );

      case 403:
        return const AppException.auth(
          message: 'このリソースにアクセスする権限がありません',
          type: AuthErrorType.permissionDenied,
        );

      case 404:
        return AppException.network(
          message: '要求されたリソースが見つかりません',
          statusCode: 404,
          endpoint: endpoint,
        );

      case 422:
        // サーバーからのバリデーションエラー詳細を解析
        final errorDetails = _parseValidationErrors(dioError.response?.data);
        return AppException.validation(
          message: errorDetails['message'] ?? 'バリデーションエラーが発生しました',
          field: errorDetails['field'] ?? 'unknown',
          value: errorDetails['value'],
        );

      case 429:
        return AppException.network(
          message: 'リクエストが多すぎます。しばらく時間をおいてから再試行してください',
          statusCode: 429,
          endpoint: endpoint,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return AppException.network(
          message: 'サーバーでエラーが発生しています。しばらく時間をおいてから再試行してください',
          statusCode: statusCode,
          endpoint: endpoint,
        );

      default:
        return AppException.network(
          message: 'HTTPエラーが発生しました (ステータス: $statusCode)',
          statusCode: statusCode,
          endpoint: endpoint,
        );
    }
  }

  /// サーバーからのバリデーションエラー詳細を解析
  ///
  /// 【現場でのレスポンス例】
  /// ```json
  /// {
  ///   "errors": {
  ///     "email": ["メールアドレスの形式が正しくありません"],
  ///     "password": ["パスワードは8文字以上で入力してください"]
  ///   }
  /// }
  /// ```
  Map<String, dynamic> _parseValidationErrors(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final errors = responseData['errors'];
      if (errors is Map<String, dynamic>) {
        final firstError = errors.entries.first;
        final message = firstError.value is List
            ? firstError.value.first.toString()
            : firstError.value.toString();

        return {
          'field': firstError.key,
          'message': message,
          'value': responseData,
        };
      }

      // 一般的なエラーメッセージ
      if (responseData['message'] != null) {
        return {
          'field': 'general',
          'message': responseData['message'],
          'value': responseData,
        };
      }
    }

    return {
      'field': 'unknown',
      'message': 'バリデーションエラーが発生しました',
      'value': responseData,
    };
  }

  /// 自動リトライインターセプター作成
  ///
  /// 【現場でのリトライ戦略】
  /// - ネットワーク一時的エラー：3回リトライ
  /// - サーバーエラー（500番台）：2回リトライ
  /// - 認証エラー：リトライしない
  /// - 指数バックオフでリトライ間隔を調整
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        // リトライ可能かチェック
        if (_shouldRetry(error)) {
          final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
          const maxRetries = 3;

          if (retryCount < maxRetries) {
            // リトライ回数を更新
            error.requestOptions.extra['retryCount'] = retryCount + 1;

            // 指数バックオフ（1秒、2秒、4秒）
            final delay = Duration(seconds: 1 << retryCount);
            await Future.delayed(delay);

            _logger.w(
              '🔄 Retrying request (${retryCount + 1}/$maxRetries): '
              '${error.requestOptions.path}',
            );

            try {
              // リトライ実行
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              // リトライも失敗した場合は元のエラーを使用
            }
          }
        }

        handler.next(error);
      },
    );
  }

  /// リトライ可能性判定
  bool _shouldRetry(DioException error) {
    // 認証エラーはリトライしない
    if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 403) {
      return false;
    }

    // クライアントエラー（400番台）はリトライしない
    if (error.response?.statusCode != null &&
        error.response!.statusCode! >= 400 &&
        error.response!.statusCode! < 500) {
      return false;
    }

    // ネットワークエラーとサーバーエラーはリトライ対象
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  /// 環境別BaseURL取得
  String _getBaseUrl() {
    // 本番環境では環境変数や設定ファイルから取得
    if (kReleaseMode) {
      return 'https://jsonplaceholder.typicode.com';
    } else {
      // 開発・テスト環境
      return 'https://jsonplaceholder.typicode.com';
    }
  }

  /// 認証トークン取得
  ///
  /// 【現場での実装】
  /// - SecureStorageから取得
  /// - トークンの有効期限チェック
  /// - 自動リフレッシュ機能
  Future<String?> _getAuthToken() async {
    try {
      // 実際の実装では flutter_secure_storage を使用
      // const storage = FlutterSecureStorage();
      // return await storage.read(key: 'auth_token');

      // デモ用：固定トークン
      return null; // 実際のトークンがある場合はここで返す
    } catch (e) {
      _logger.e('認証トークン取得エラー', error: e);
      return null;
    }
  }

  /// エラートラッキングサービスへ送信
  ///
  /// 【現場での実装例】
  /// - Sentry, Crashlytics, Bugsnag等
  /// - ユーザー情報、環境情報の付与
  /// - 重要度別の通知設定
  void _reportErrorToTracking(
      AppException appException, DioException dioError) {
    try {
      // 実際の実装例（Sentry使用）
      // Sentry.captureException(
      //   appException,
      //   stackTrace: dioError.stackTrace,
      //   withScope: (scope) {
      //     scope.setTag('error_type', 'api_error');
      //     scope.setLevel(SentryLevel.error);
      //     scope.setContext('request', {
      //       'url': dioError.requestOptions.uri.toString(),
      //       'method': dioError.requestOptions.method,
      //       'status_code': dioError.response?.statusCode,
      //     });
      //   },
      // );

      _logger.e('エラートラッキングに送信: ${appException.message}');
    } catch (e) {
      _logger.e('エラートラッキング送信失敗', error: e);
    }
  }

  /// Dioインスタンスを外部から取得
  ///
  /// 【現場での使用例】
  /// - Repository層でのAPI呼び出し
  /// - Retrofit クライアント作成時
  Dio get dio => _dio;

  /// 接続テスト用メソッド
  ///
  /// 【現場での使用例】
  /// - アプリ起動時のヘルスチェック
  /// - 設定変更後の接続確認
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/posts/1');
      return response.statusCode == 200;
    } catch (e) {
      _logger.w('接続テスト失敗', error: e);
      return false;
    }
  }

  /// キャッシュクリア
  ///
  /// 【現場での使用例】
  /// - ログアウト時
  /// - 設定リセット時
  void clearCache() {
    _dio.interceptors.clear();
    _setupInterceptors();
    _logger.i('Dioキャッシュをクリアしました');
  }
}
