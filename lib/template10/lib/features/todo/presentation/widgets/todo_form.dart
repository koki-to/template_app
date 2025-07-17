import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({
    super.key,
    required this.isCreating,
    required this.onSubmit,
    required this.onCancel,
    this.initialTitle = '',
    this.initialDescription = '',
    this.isLoading = false,
  });

  final bool isCreating;
  final String initialTitle;
  final String initialDescription;
  final bool isLoading;
  final Future<void> Function(String title, String description) onSubmit;
  final VoidCallback onCancel;

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    
    // 作成時は自動でタイトルフィールドにフォーカス
    if (widget.isCreating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessing = _isSubmitting || widget.isLoading;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // タイトル入力欄
            TextFormField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              decoration: InputDecoration(
                labelText: 'タイトル *',
                hintText: 'Todoのタイトルを入力してください',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
                counterText: '${_titleController.text.length}/100',
              ),
              maxLength: 100,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                _descriptionFocusNode.requestFocus();
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'タイトルを入力してください';
                }
                if (value.trim().length < 1) {
                  return 'タイトルは1文字以上で入力してください';
                }
                if (value.length > 100) {
                  return 'タイトルは100文字以内で入力してください';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            // 説明入力欄
            TextFormField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              decoration: InputDecoration(
                labelText: '説明 *',
                hintText: 'Todoの詳細な説明を入力してください',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
                counterText: '${_descriptionController.text.length}/500',
              ),
              maxLines: 5,
              maxLength: 500,
              textInputAction: TextInputAction.newline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '説明を入力してください';
                }
                if (value.trim().length < 1) {
                  return '説明は1文字以上で入力してください';
                }
                if (value.length > 500) {
                  return '説明は500文字以内で入力してください';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),

            // 文字数インジケーター
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'タイトル: ${_titleController.text.length}/100',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _titleController.text.length > 80
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline,
                  ),
                ),
                Text(
                  '説明: ${_descriptionController.text.length}/500',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _descriptionController.text.length > 400
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // アクションボタン
            Row(
              children: [
                // キャンセルボタン
                Expanded(
                  child: OutlinedButton(
                    onPressed: isProcessing ? null : widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('キャンセル'),
                  ),
                ),

                const SizedBox(width: 16),

                // 保存ボタン
                Expanded(
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isProcessing
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(widget.isCreating ? '作成' : '更新'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // フォームのヒント
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ヒント',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• 具体的で実行可能なタイトルを設定しましょう\n'
                    '• 説明には詳細な手順や注意点を記載すると便利です\n'
                    '• 必要に応じて期限や優先度を説明に含めましょう',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}