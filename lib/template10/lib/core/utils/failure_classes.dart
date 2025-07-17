/// アプリケーション全体で使用するFailureの基底クラス
abstract class Failure {
  const Failure(this.message);
  
  final String message;

  @override
  String toString() => 'Failure: $message';
}

/// データベース関連のエラー
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
  
  factory DatabaseFailure.insert() => const DatabaseFailure('データの挿入に失敗しました');
  factory DatabaseFailure.update() => const DatabaseFailure('データの更新に失敗しました');
  factory DatabaseFailure.delete() => const DatabaseFailure('データの削除に失敗しました');
  factory DatabaseFailure.fetch() => const DatabaseFailure('データの取得に失敗しました');
  factory DatabaseFailure.connection() => const DatabaseFailure('データベースへの接続に失敗しました');
}

/// バリデーション関連のエラー
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
  
  factory ValidationFailure.emptyTitle() => const ValidationFailure('タイトルを入力してください');
  factory ValidationFailure.emptyDescription() => const ValidationFailure('説明を入力してください');
  factory ValidationFailure.invalidId() => const ValidationFailure('無効なIDです');
  factory ValidationFailure.todoNotFound() => const ValidationFailure('指定されたTodoが見つかりません');
}

/// ネットワーク関連のエラー（将来の拡張用）
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
  
  factory NetworkFailure.noConnection() => const NetworkFailure('インターネット接続がありません');
  factory NetworkFailure.timeout() => const NetworkFailure('接続がタイムアウトしました');
  factory NetworkFailure.serverError() => const NetworkFailure('サーバーエラーが発生しました');
}

/// 一般的なエラー
class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
  
  factory GeneralFailure.unknown() => const GeneralFailure('予期しないエラーが発生しました');
}