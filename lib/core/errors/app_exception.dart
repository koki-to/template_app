import 'package:freezed_annotation/freezed_annotation.dart';

// 🔧 コード生成用のファイル指定
// これらのファイルはbuild_runnerが自動生成します
part 'app_exception.freezed.dart';

/// アプリケーション全体で発生するエラーを統一管理するクラス
///
/// 【現場での使い方】
/// - APIエラー、ネットワークエラー、バリデーションエラーなど
///   すべてのエラーをこのクラスで統一管理
/// - switch文やパターンマッチングで適切な処理を分岐
/// - ユーザーに表示するメッセージと開発者向けログを分離
@freezed
sealed class AppException with _$AppException implements Exception {
  // 🌐 ネットワーク関連エラー
  // 例：インターネット接続なし、サーバーダウン、タイムアウト
  const factory AppException.network({
    required String message, // 開発者向けメッセージ
    int? statusCode, // HTTPステータスコード（404、500など）
    String? endpoint, // エラーが発生したAPI endpoint
  }) = NetworkException;

  // 🔐 認証・認可エラー
  // 例：ログイン失敗、トークン期限切れ、権限不足
  const factory AppException.auth({
    required String message,
    @Default(AuthErrorType.unknown) AuthErrorType type, // エラーの詳細分類
  }) = AuthException;

  // ✅ バリデーションエラー
  // 例：入力必須項目未入力、文字数制限オーバー、形式不正
  const factory AppException.validation({
    required String message,
    required String field, // エラーが発生したフィールド名
    dynamic value, // エラーの原因となった入力値
  }) = ValidationException;

  // 💼 ビジネスロジックエラー
  // 例：在庫不足、重複登録、業務ルール違反
  const factory AppException.business({
    required String message,
    required String code, // エラーコード（例：INSUFFICIENT_STOCK）
    Map<String, dynamic>? details, // 追加詳細情報
  }) = BusinessException;

  // ⚙️ システムエラー（予期しないエラー）
  // 例：想定外の例外、プログラムバグ、システム障害
  const factory AppException.system({
    required String message,
    Object? originalError, // 元の例外オブジェクト
    StackTrace? stackTrace, // スタックトレース（デバッグ用）
  }) = SystemException;

  // 📊 データ関連エラー
  // 例：JSON解析失敗、データ不整合、データ見つからず
  const factory AppException.data({
    required String message,
    @Default(DataErrorType.parseError) DataErrorType type,
    Object? originalData, // エラーの原因となったデータ
  }) = DataException;
}

// ===============================
// 🏷️ エラー詳細分類用のEnum
// ===============================

/// 認証エラーの詳細分類
///
/// 【現場での使い方】
/// - エラーの種類に応じて適切な画面遷移やメッセージ表示を行う
/// - 例：tokenExpired → ログイン画面へ自動遷移
enum AuthErrorType {
  tokenExpired, // トークン期限切れ
  invalidCredentials, // ユーザー名・パスワード不正
  accountLocked, // アカウントロック
  accountNotFound, // アカウント見つからず
  permissionDenied, // 権限不足
  unknown, // 不明なエラー
}

/// データエラーの詳細分類
enum DataErrorType {
  parseError, // JSON解析エラー
  notFound, // データ見つからず
  corrupted, // データ破損
  versionMismatch, // バージョン不整合
  unknown, // 不明なエラー
}

/// エラーの重要度レベル
///
/// 【現場での使い方】
/// - ログ出力レベルの制御
/// - 通知・アラートの優先度判定
/// - 監視システムとの連携
enum ErrorLevel {
  info, // 情報レベル（例：バリデーションエラー）
  warning, // 警告レベル（例：ネットワーク一時的エラー）
  error, // エラーレベル（例：認証エラー）
  critical, // 重大レベル（例：システム障害）
}

// ===============================
// 🛠️ AppException の便利な拡張メソッド
// ===============================

/// AppExceptionに便利なメソッドを追加する拡張
///
/// 【現場での使い方】
/// - UIでエラー表示する際の共通処理を提供
/// - エラーレベルに応じた自動処理の実装
extension AppExceptionExtension on AppException {
  /// エラーの重要度レベルを判定
  ///
  /// 【使用例】
  /// ```dart
  /// if (error.level == ErrorLevel.critical) {
  ///   // 緊急対応が必要なエラー
  ///   await sendAlertToAdmin(error);
  /// }
  /// ```
  ErrorLevel get level {
    return switch (this) {
      // サーバーエラー（500番台）は重大
      NetworkException(statusCode: final code)
          when code != null && code >= 500 =>
        ErrorLevel.critical,
      // その他のネットワークエラーは警告
      NetworkException() => ErrorLevel.warning,
      // 認証エラーは通常エラー
      AuthException() => ErrorLevel.error,
      // バリデーションエラーは情報レベル
      ValidationException() => ErrorLevel.info,
      // ビジネスエラーは警告
      BusinessException() => ErrorLevel.warning,
      // システムエラーは重大
      SystemException() => ErrorLevel.critical,
      // データエラーは通常エラー
      DataException() => ErrorLevel.error,
    };
  }
}
