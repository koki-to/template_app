import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Template2Page extends HookWidget {
  const Template2Page({super.key});

  @override
  Widget build(BuildContext context) {
    // useTextEditingControllerを使って、テキスト入力のコントローラーを管理
    final textController = useTextEditingController();

    // useStateを使って、表示するテキストを管理
    final displayedText = useState('');

    return Scaffold(
      appBar: AppBar(title: const Text('Hooksテキスト入力')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController, // ここでコントローラーを渡す
              decoration: const InputDecoration(
                labelText: '何か入力してください',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                // 入力があるたびにdisplayedTextを更新
                displayedText.value = text;
              },
            ),
            const SizedBox(height: 20),
            Text('入力されたテキスト: ${displayedText.value}'),
          ],
        ),
      ),
    );
  }
}
