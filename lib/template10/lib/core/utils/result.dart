import 'package:template_app/template10/lib/core/utils/failure_classes.dart';

/// 成功/失敗を表現するSealed Class
sealed class Result<T> {
  const Result();

  /// 成功時のデータを取得（失敗時はnullを返す）
  T? get data => switch (this) {
        Success(data: final data) => data,
        Error() => null,
      };

  /// 失敗時のエラーを取得（成功時はnullを返す）
  Failure? get failure => switch (this) {
        Success() => null,
        Error(failure: final failure) => failure,
      };

  /// 成功かどうかを判定
  bool get isSuccess => this is Success<T>;

  /// 失敗かどうかを判定
  bool get isError => this is Error<T>;

  /// 成功時のコールバックを実行
  Result<U> map<U>(U Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => Success(mapper(data)),
      Error(failure: final failure) => Error(failure),
    };
  }

  /// 成功時のみコールバックを実行（副作用）
  void when({
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onError,
  }) {
    switch (this) {
      case Success(data: final data):
        onSuccess(data);
      case Error(failure: final failure):
        onError(failure);
    }
  }

  /// 成功時のみコールバックを実行（値を返す）
  U fold<U>({
    required U Function(T data) onSuccess,
    required U Function(Failure failure) onError,
  }) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Error(failure: final failure) => onError(failure),
    };
  }
}

/// 成功を表すクラス
class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success(data: $data)';
}

/// 失敗を表すクラス
class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Error(failure: $failure)';
}

/// Result型の便利な拡張メソッド
extension ResultExtensions<T> on Result<T> {
  /// 成功時のデータを取得（失敗時は例外を投げる）
  T get dataOrThrow => switch (this) {
        Success(data: final data) => data,
        Error(failure: final failure) => throw Exception(failure.message),
      };

  /// 成功時のデータを取得（失敗時はデフォルト値を返す）
  T getOrElse(T defaultValue) => switch (this) {
        Success(data: final data) => data,
        Error() => defaultValue,
      };
}

/// Future<Result<T>>の便利な拡張メソッド
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// 非同期処理の結果に対してmapを適用
  Future<Result<U>> mapAsync<U>(Future<U> Function(T data) mapper) async {
    final result = await this;
    return switch (result) {
      Success(data: final data) => Success(await mapper(data)),
      Error(failure: final failure) => Error(failure),
    };
  }

  /// 非同期処理の結果に対してwhenを適用
  Future<void> whenAsync({
    required Future<void> Function(T data) onSuccess,
    required Future<void> Function(Failure failure) onError,
  }) async {
    final result = await this;
    switch (result) {
      case Success(data: final data):
        await onSuccess(data);
      case Error(failure: final failure):
        await onError(failure);
    }
  }
}
