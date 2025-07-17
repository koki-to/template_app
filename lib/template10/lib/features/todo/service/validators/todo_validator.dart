import 'package:template_app/template10/lib/core/utils/failure_classes.dart';

import '../../../../core/utils/result.dart';

/// Todo関連のバリデーションを行うクラス
class TodoValidator {
  // 制約定数
  static const int minTitleLength = 1;
  static const int maxTitleLength = 100;
  static const int minDescriptionLength = 1;
  static const int maxDescriptionLength = 500;
  static const int maxSearchQueryLength = 50;

  /// タイトルのバリデーション
  static Result<String> validateTitle(String title) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      return Error(ValidationFailure.emptyTitle());
    }

    if (trimmedTitle.length < minTitleLength) {
      return const Error(
          ValidationFailure('タイトルは$minTitleLength文字以上で入力してください'));
    }

    if (trimmedTitle.length > maxTitleLength) {
      return const Error(
          ValidationFailure('タイトルは$maxTitleLength文字以内で入力してください'));
    }

    // HTMLタグや特殊文字のチェック
    if (_containsHtmlTags(trimmedTitle)) {
      return const Error(ValidationFailure('タイトルにHTMLタグは使用できません'));
    }

    return Success(trimmedTitle);
  }

  /// 説明のバリデーション
  static Result<String> validateDescription(String description) {
    final trimmedDescription = description.trim();

    if (trimmedDescription.isEmpty) {
      return Error(ValidationFailure.emptyDescription());
    }

    if (trimmedDescription.length < minDescriptionLength) {
      return const Error(
          ValidationFailure('説明は$minDescriptionLength文字以上で入力してください'));
    }

    if (trimmedDescription.length > maxDescriptionLength) {
      return const Error(
          ValidationFailure('説明は$maxDescriptionLength文字以内で入力してください'));
    }

    // HTMLタグのチェック
    if (_containsHtmlTags(trimmedDescription)) {
      return const Error(ValidationFailure('説明にHTMLタグは使用できません'));
    }

    return Success(trimmedDescription);
  }

  /// IDのバリデーション
  static Result<String> validateId(String id) {
    final trimmedId = id.trim();

    if (trimmedId.isEmpty) {
      return Error(ValidationFailure.invalidId());
    }

    // UUID形式のチェック（簡易版）
    if (!_isValidUuid(trimmedId)) {
      return const Error(ValidationFailure('無効なID形式です'));
    }

    return Success(trimmedId);
  }

  /// 検索クエリのバリデーション
  static Result<String> validateSearchQuery(String query) {
    final trimmedQuery = query.trim();

    // 空文字は許可（全件取得）
    if (trimmedQuery.isEmpty) {
      return Success(trimmedQuery);
    }

    if (trimmedQuery.length > maxSearchQueryLength) {
      return const Error(
          ValidationFailure('検索キーワードは$maxSearchQueryLength文字以内で入力してください'));
    }

    // SQLインジェクション対策の基本チェック
    if (_containsSqlInjectionPattern(trimmedQuery)) {
      return const Error(ValidationFailure('検索キーワードに無効な文字が含まれています'));
    }

    return Success(trimmedQuery);
  }

  /// 複数のIDを一括バリデーション
  static Result<List<String>> validateIds(List<String> ids) {
    if (ids.isEmpty) {
      return const Error(ValidationFailure('削除するアイテムが選択されていません'));
    }

    final validatedIds = <String>[];

    for (final id in ids) {
      final result = validateId(id);
      if (result.isError) {
        return Error(result.failure!);
      }
      validatedIds.add(result.data!);
    }

    return Success(validatedIds);
  }

  /// Todo作成用の包括的バリデーション
  static Result<Map<String, String>> validateTodoCreation({
    required String title,
    required String description,
  }) {
    final titleResult = validateTitle(title);
    if (titleResult.isError) {
      return Error(titleResult.failure!);
    }

    final descriptionResult = validateDescription(description);
    if (descriptionResult.isError) {
      return Error(descriptionResult.failure!);
    }

    return Success({
      'title': titleResult.data!,
      'description': descriptionResult.data!,
    });
  }

  /// Todo更新用の包括的バリデーション
  static Result<Map<String, String>> validateTodoUpdate({
    required String id,
    required String title,
    required String description,
  }) {
    final idResult = validateId(id);
    if (idResult.isError) {
      return Error(idResult.failure!);
    }

    final titleResult = validateTitle(title);
    if (titleResult.isError) {
      return Error(titleResult.failure!);
    }

    final descriptionResult = validateDescription(description);
    if (descriptionResult.isError) {
      return Error(descriptionResult.failure!);
    }

    return Success({
      'id': idResult.data!,
      'title': titleResult.data!,
      'description': descriptionResult.data!,
    });
  }

  // プライベートヘルパーメソッド

  /// HTMLタグが含まれているかチェック
  static bool _containsHtmlTags(String text) {
    final htmlTagPattern = RegExp(r'<[^>]*>');
    return htmlTagPattern.hasMatch(text);
  }

  /// UUID形式かどうかチェック（簡易版）
  static bool _isValidUuid(String id) {
    final uuidPattern = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    return uuidPattern.hasMatch(id);
  }

  /// SQLインジェクションパターンのチェック
  static bool _containsSqlInjectionPattern(String text) {
    final sqlInjectionPatterns = [
      RegExp(r"'", caseSensitive: false),
      RegExp(r'"', caseSensitive: false),
      RegExp(r'--', caseSensitive: false),
      RegExp(r'/\*', caseSensitive: false),
      RegExp(r'\*/', caseSensitive: false),
      RegExp(r';', caseSensitive: false),
    ];

    return sqlInjectionPatterns.any((pattern) => pattern.hasMatch(text));
  }
}
