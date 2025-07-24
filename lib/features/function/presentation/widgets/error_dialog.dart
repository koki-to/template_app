// lib/presentation/widgets/error_widgets.dart
// 現場で使える実用的なエラー表示ウィジェット集

import 'package:flutter/material.dart';
import 'package:template_app/core/errors/app_exception.dart';

// ===============================
// 🎨 ErrorDisplayWidget：基本エラー表示
// ===============================

/// 基本的なエラー表示ウィジェット
///
/// 【現場での使用例】
/// ```dart
/// ErrorDisplayWidget(
///   error: appException,
///   onRetry: () => ref.refresh(dataProvider),
/// )
/// ```
class ErrorDisplayWidget extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool showDetails;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // エラーアイコン
            Icon(
              Icons.error,
              size: 64,
              color: _getErrorColor(context),
            ),

            const SizedBox(height: 16),

            // エラーメッセージ
            Text(
              error.message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getErrorColor(context),
                  ),
              textAlign: TextAlign.center,
            ),

            if (showDetails) ...[
              const SizedBox(height: 8),
              Text(
                'エラー詳細: ${error.message}',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 24),

            // アクションボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (error.isRetryable && onRetry != null) ...[
                //   ElevatedButton.icon(
                //     onPressed: onRetry,
                //     icon: const Icon(Icons.refresh),
                //     label: const Text('再試行'),
                //   ),
                //   if (onDismiss != null) const SizedBox(width: 12),
                // ],
                if (onDismiss != null)
                  OutlinedButton(
                    onPressed: onDismiss,
                    child: const Text('閉じる'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getErrorColor(BuildContext context) {
    return switch (error.level) {
      ErrorLevel.critical => Colors.red.shade700,
      ErrorLevel.error => Theme.of(context).colorScheme.error,
      ErrorLevel.warning => Colors.orange.shade600,
      ErrorLevel.info => Theme.of(context).colorScheme.primary,
    };
  }
}

// ===============================
// 🌐 NetworkErrorWidget：ネットワークエラー専用
// ===============================

/// ネットワークエラー専用ウィジェット
class NetworkErrorWidget extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ネットワークアイコン
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off,
                size: 50,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              _getNetworkErrorTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              error.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              _getNetworkSolution(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('再接続'),
              ),
          ],
        ),
      ),
    );
  }

  String _getNetworkErrorTitle() {
    if (error case NetworkException(statusCode: final code)) {
      if (code == null) return '接続エラー';
      if (code >= 500) return 'サーバーエラー';
      if (code == 404) return 'ページが見つかりません';
      return 'ネットワークエラー';
    }
    return 'ネットワークエラー';
  }

  String _getNetworkSolution() {
    if (error case NetworkException(statusCode: final code)) {
      if (code == null) return 'ネットワーク接続を確認してから再試行してください';
      if (code >= 500) return 'サーバーの問題です。しばらく待ってから再試行してください';
      if (code == 429) return 'アクセスが集中しています。しばらく待ってから再試行してください';
    }
    return 'ネットワーク環境を確認してから再試行してください';
  }
}

// ===============================
// 🔔 ErrorSnackBar：エラー通知バー
// ===============================

/// エラー用SnackBar表示クラス
class ErrorSnackBar {
  static void show(BuildContext context, AppException error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error.message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: _getSnackBarColor(error.level),
      duration: _getSnackBarDuration(error.level),
      // action: error.isRetryable
      //     ? SnackBarAction(
      //         label: '再試行',
      //         textColor: Colors.white,
      //         onPressed: () {
      //           // リトライ処理は外部から注入
      //         },
      //       )
      //     : null,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getSnackBarColor(ErrorLevel level) {
    return switch (level) {
      ErrorLevel.critical => Colors.red.shade700,
      ErrorLevel.error => Colors.red.shade600,
      ErrorLevel.warning => Colors.orange.shade600,
      ErrorLevel.info => Colors.blue.shade600,
    };
  }

  static Duration _getSnackBarDuration(ErrorLevel level) {
    return switch (level) {
      ErrorLevel.critical => const Duration(seconds: 8),
      ErrorLevel.error => const Duration(seconds: 6),
      ErrorLevel.warning => const Duration(seconds: 4),
      ErrorLevel.info => const Duration(seconds: 3),
    };
  }
}

// ===============================
// 📝 ValidationErrorWidget：バリデーションエラー
// ===============================

/// フォームバリデーションエラー表示
class ValidationErrorWidget extends StatelessWidget {
  final ValidationException error;

  const ValidationErrorWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// 🚨 CriticalErrorDialog：重大エラーダイアログ
// ===============================

/// 重大エラー専用ダイアログ
class CriticalErrorDialog extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRestart;

  const CriticalErrorDialog({
    super.key,
    required this.error,
    this.onRestart,
  });

  static Future<void> show(
    BuildContext context,
    AppException error, {
    VoidCallback? onRestart,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CriticalErrorDialog(
        error: error,
        onRestart: onRestart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.red.shade700,
          ),
          const SizedBox(width: 8),
          const Text('重大なエラー'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(error.message),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('アプリを再起動する必要があります'),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: onRestart ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
          ),
          child: const Text('再起動'),
        ),
      ],
    );
  }
}

// ===============================
// 🔄 LoadingErrorWidget：ローディングエラー
// ===============================

/// ローディング中エラー表示
class LoadingErrorWidget extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;
  final String? loadingText;

  const LoadingErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            loadingText ?? '読み込み中にエラーが発生しました',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('再試行'),
            ),
          ],
        ],
      ),
    );
  }
}

// ===============================
// 📊 ErrorSummaryWidget：エラー統計
// ===============================

/// エラー統計表示ウィジェット（開発・デバッグ用）
class ErrorSummaryWidget extends StatelessWidget {
  final bool showDetails;

  const ErrorSummaryWidget({
    super.key,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final errorStats = _getMockErrorStats();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'エラー統計',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildErrorCount(
                'ネットワークエラー', errorStats['network'] ?? 0, Colors.orange),
            _buildErrorCount('認証エラー', errorStats['auth'] ?? 0, Colors.red),
            _buildErrorCount(
                'バリデーションエラー', errorStats['validation'] ?? 0, Colors.blue),
            _buildErrorCount(
                'システムエラー', errorStats['system'] ?? 0, Colors.purple),
            if (showDetails) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                '直近のエラー',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ..._getRecentErrors().map(_buildErrorItem),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCount(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            '$count件',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorItem(Map<String, dynamic> error) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error['message'] ?? 'Unknown error',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            error['time'] ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _getMockErrorStats() {
    return {
      'network': 3,
      'auth': 1,
      'validation': 5,
      'system': 0,
    };
  }

  List<Map<String, dynamic>> _getRecentErrors() {
    return [
      {'message': 'ネットワーク接続エラー', 'time': '10:30'},
      {'message': 'タイトルが空です', 'time': '10:25'},
      {'message': 'サーバーエラー (500)', 'time': '10:20'},
    ];
  }
}

// ===============================
// 🔧 ErrorWidgetUtils：ユーティリティ
// ===============================

/// エラーウィジェット関連のユーティリティクラス
class ErrorWidgetUtils {
  /// AsyncValueのエラーを適切なウィジェットで表示
  static Widget handleAsyncError(
    Object error,
    StackTrace stackTrace, {
    VoidCallback? onRetry,
    bool showDetails = false,
  }) {
    final appException = error is AppException
        ? error
        : AppException.system(
            message: '予期しないエラーが発生しました',
            originalError: error,
            stackTrace: stackTrace,
          );

    if (appException is NetworkException) {
      return NetworkErrorWidget(
        error: appException,
        onRetry: onRetry,
      );
    }

    return ErrorDisplayWidget(
      error: appException,
      onRetry: onRetry,
      showDetails: showDetails,
    );
  }

  /// エラーアラートダイアログ表示
  static Future<void> showErrorAlert(
    BuildContext context,
    AppException error, {
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error),
            const SizedBox(width: 8),
            const Text('エラー'),
          ],
        ),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
          // if (onRetry != null && error.isRetryable)
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       onRetry();
          //     },
          //     child: const Text('再試行'),
          //   ),
        ],
      ),
    );
  }

  /// デバッグ用エラーウィジェット
  static Widget debugErrorWidget(
    AppException error, {
    VoidCallback? onRetry,
  }) {
    return Column(
      children: [
        ErrorDisplayWidget(
          error: error,
          onRetry: onRetry,
          showDetails: true,
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'デバッグ情報:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Text(
              //   error.technicalDetails,
              //   style: const TextStyle(
              //     fontFamily: 'monospace',
              //     fontSize: 12,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===============================
// 📱 エラーハンドリングデモ画面
// ===============================

/// エラーハンドリング機能のデモ画面
class ErrorHandlingDemoScreen extends StatelessWidget {
  const ErrorHandlingDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('エラーハンドリングデモ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'エラーハンドリング機能デモ',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '以下のボタンでそれぞれのエラータイプの表示を確認できます。',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // デモボタン群
          _DemoSection(
            title: 'ネットワークエラー',
            color: Colors.orange,
            buttons: [
              _DemoButton(
                label: '接続エラー',
                onPressed: () => _showNetworkError(context, null),
              ),
              _DemoButton(
                label: 'サーバーエラー',
                onPressed: () => _showNetworkError(context, 500),
              ),
            ],
          ),

          _DemoSection(
            title: '認証エラー',
            color: Colors.red,
            buttons: [
              _DemoButton(
                label: 'トークン期限切れ',
                onPressed: () => _showAuthError(context),
              ),
            ],
          ),

          _DemoSection(
            title: 'バリデーションエラー',
            color: Colors.blue,
            buttons: [
              _DemoButton(
                label: '入力エラー',
                onPressed: () => _showValidationError(context),
              ),
            ],
          ),

          _DemoSection(
            title: '表示形式',
            color: Colors.green,
            buttons: [
              _DemoButton(
                label: 'SnackBar',
                onPressed: () => _showSnackBarError(context),
              ),
              _DemoButton(
                label: 'ダイアログ',
                onPressed: () => _showDialogError(context),
              ),
              _DemoButton(
                label: '重大エラー',
                onPressed: () => _showCriticalError(context),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const ErrorSummaryWidget(showDetails: true),
        ],
      ),
    );
  }

  void _showNetworkError(BuildContext context, int? statusCode) {
    final error = AppException.network(
      message: statusCode == null ? 'ネットワーク接続エラー' : 'サーバーエラー: $statusCode',
      statusCode: statusCode,
      endpoint: '/api/demo',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: NetworkErrorWidget(
            error: error,
            onRetry: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  void _showAuthError(BuildContext context) {
    const error = AppException.auth(
      message: 'セッションが期限切れです',
      type: AuthErrorType.tokenExpired,
    );

    ErrorSnackBar.show(context, error);
  }

  void _showValidationError(BuildContext context) {
    const error = ValidationException(
      message: 'タイトルを入力してください',
      field: 'title',
      value: '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ValidationErrorWidget(error: error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  void _showSnackBarError(BuildContext context) {
    const error = AppException.business(
      message: 'SnackBar形式のエラー表示例',
      code: 'DEMO_ERROR',
    );

    ErrorSnackBar.show(context, error);
  }

  void _showDialogError(BuildContext context) {
    final error = AppException.system(
      message: 'システムエラーが発生しました',
      originalError: Exception('デモエラー'),
    );

    ErrorWidgetUtils.showErrorAlert(context, error);
  }

  void _showCriticalError(BuildContext context) {
    final error = AppException.system(
      message: '重大なシステムエラーが発生しました',
      originalError: Exception('重大エラー'),
    );

    CriticalErrorDialog.show(context, error);
  }
}

/// デモセクションウィジェット
class _DemoSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget> buttons;

  const _DemoSection({
    required this.title,
    required this.color,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }
}

/// デモボタンウィジェット
class _DemoButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DemoButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
