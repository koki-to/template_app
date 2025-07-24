// lib/core/result/result.dart
// 現場で必須のResult型パターン（初学者向け詳細解説）

import 'package:freezed_annotation/freezed_annotation.dart';
import '../errors/app_exception.dart';

// 🔧 コード生成用ファイル指定
part 'result.freezed.dart';

// ===============================
// 🎯 Result型：成功・失敗を型安全に表現
// ===============================

/// API呼び出しやビジネスロジックの結果を安全に表現するクラス
///
/// 【現場での重要性】
/// - 例外を使わずに、成功・失敗を明確に型で表現
/// - コンパイル時にエラーハンドリング漏れを防止
/// - 関数型プログラミングのコンセプトを取り入れた安全な設計
///
/// 【使用例】
/// ```dart
/// Future<Result<User>> getUser(String id) async {
///   try {
///     final user = await apiClient.getUser(id);
///     return Result.success(user);  // 成功時
///   } catch (e) {
///     return Result.failure(AppException.network(...));  // 失敗時
///   }
/// }
/// ```
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppException error) = Failure<T>;
}

extension ResultExtension<T> on Result<T> {
  /// 成功時のデータを取得（失敗時はnull）
  ///
  /// 【使用例】
  /// ```dart
  /// final result = await getUser('123');
  /// final user = result.data;  // User? または null
  /// if (user != null) {
  ///   print('ユーザー名: ${user.name}');
  /// }
  /// ```
  T? get data {
    return switch (this) {
      Success(data: final data) => data,
      Failure() => null,
    };
  }

  /// 失敗時のエラーを取得（成功時はnull）
  AppException? get error {
    return switch (this) {
      Success() => null,
      Failure(error: final error) => error,
    };
  }

  /// 成功かどうかの判定
  ///
  /// 【使用例】
  /// ```dart
  /// if (result.isSuccess) {
  ///   // 成功時の処理
  ///   showSuccessMessage();
  /// }
  /// ```
  bool get isSuccess => this is Success<T>;

  /// 失敗かどうかの判定
  bool get isFailure => this is Failure<T>;

  /// データが存在するかどうか
  bool get hasData => data != null;

  /// エラーが存在するかどうか
  bool get hasError => error != null;

  /// データ変換（成功時のみ）
  ///
  /// 【現場での使い方】
  /// - APIから取得したデータを別の形式に変換
  /// - エラー状態は保持したまま、成功データのみを変換
  ///
  /// 【使用例】
  /// ```dart
  /// final userResult = await getUser('123');
  /// final nameResult = userResult.map((user) => user.name);
  /// // Result<User> → Result<String> に変換
  /// ```
  Result<U> map<U>(U Function(T data) transform) {
    return switch (this) {
      Success(data: final data) => Result.success(transform(data)),
      Failure(error: final error) => Result.failure(error),
    };
  }

  /// 非同期データ変換
  ///
  /// 【現場での使い方】
  /// - APIレスポンスをさらに別のAPIで処理する場合
  /// - 画像処理、データ加工などの非同期処理
  ///
  /// 【使用例】
  /// ```dart
  /// final userResult = await getUser('123');
  /// final profileResult = await userResult.mapAsync((user) async {
  ///   return await getUserProfile(user.id);
  /// });
  /// ```
  Future<Result<U>> mapAsync<U>(Future<U> Function(T data) transform) async {
    switch (this) {
      case Success(data: final data):
        try {
          final result = await transform(data);
          return Result.success(result);
        } catch (e) {
          return Result.failure(AppException.system(
            message: 'Transform failed',
            originalError: e,
          ));
        }
      case Failure(error: final error):
        return Result.failure(error);
    }
  }

  /// エラー変換（失敗時のみ）
  ///
  /// 【現場での使い方】
  /// - 低レベルエラーを高レベルエラーに変換
  /// - エラーメッセージの国際化対応
  ///
  /// 【使用例】
  /// ```dart
  /// final result = await apiCall();
  /// final localizedResult = result.mapError((error) {
  ///   return AppException.business(
  ///     message: translateErrorMessage(error),
  ///     code: 'LOCALIZED_ERROR',
  ///   );
  /// });
  /// ```
  Result<T> mapError(AppException Function(AppException error) transform) {
    return switch (this) {
      Success(data: final data) => Result.success(data),
      Failure(error: final error) => Result.failure(error),
    };
  }

  /// 成功時のコールバック実行
  ///
  /// 【現場での使い方】
  /// - 成功時のログ出力
  /// - 分析データの送信
  /// - UI更新の副作用処理
  ///
  /// 【使用例】
  /// ```dart
  /// result
  ///   .onSuccess((user) {
  ///     analytics.trackUserLoaded(user.id);
  ///     logger.info('User loaded successfully: ${user.name}');
  ///   })
  ///   .onFailure((error) {
  ///     analytics.trackError(error);
  ///   });
  /// ```
  Result<T> onSuccess(void Function(T data) action) {
    if (this case Success(data: final data)) {
      action(data);
    }
    return this;
  }

  /// 失敗時のコールバック実行
  Result<T> onFailure(void Function(AppException error) action) {
    if (this case Failure(error: final error)) {
      action(error);
    }
    return this;
  }

  /// フォールバック値の提供
  ///
  /// 【現場での使い方】
  /// - 失敗時のデフォルト値設定
  /// - 空の状態やプレースホルダーの表示
  ///
  /// 【使用例】
  /// ```dart
  /// final users = result.getOrElse(() => <User>[]);  // 空リスト
  /// final name = nameResult.getOrElse(() => '名前不明');
  /// ```
  T getOrElse(T Function() defaultValue) {
    return switch (this) {
      Success(data: final data) => data,
      Failure() => defaultValue(),
    };
  }

  /// データの取得（失敗時は例外をスロー）
  ///
  /// 【現場での使い方】
  /// - 失敗が想定されない場面での簡潔な記述
  /// - ただし、基本的にはパターンマッチングを推奨
  ///
  /// 【注意】
  /// - 例外が発生する可能性があるため、使用は慎重に
  T getOrThrow() {
    return switch (this) {
      Success(data: final data) => data,
      Failure(error: final error) => throw error,
    };
  }
}
